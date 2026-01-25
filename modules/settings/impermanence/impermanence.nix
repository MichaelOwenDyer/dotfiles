{
  inputs,
  lib,
  ...
}:
{
  # Impermanence - persist only explicitly declared state
  # https://github.com/nix-community/impermanence
  #
  # This module provides infrastructure only. Individual service modules
  # should declare their own persistence needs using the pattern:
  #
  #   config = lib.mkIf (config ? impermanence) {
  #     impermanence.persistedDirectories = [ "/var/lib/myservice" ];
  #   };

  flake.modules.nixos.impermanence =
    { config, pkgs, ... }:
    let
      cfg = config.impermanence;

      # Generate Rust arrays from the NixOS configuration
      persistedFilesRust = lib.concatMapStringsSep ", " (f: ''"${f}"'') cfg.persistedFiles;
      persistedDirsRust = lib.concatMapStringsSep ", " (d: ''"${d}"'') cfg.persistedDirectories;
      ignoredPathsRust = lib.concatMapStringsSep ", " (p: ''"${p}"'') cfg.ignoredPaths;

      # Script to check for untracked state (Rust implementation)
      impermanence-diff = pkgs.writers.writeRustBin "impermanence-diff" {} ''
        use std::{fs, path::Path, process::ExitCode};

        const COVERED_PATHS: &[&str] = &[${persistedFilesRust}, ${persistedDirsRust}, ${ignoredPathsRust}];

        mod color {
            pub const RED: &str = "\x1b[31m";
            pub const YELLOW: &str = "\x1b[33m";
            pub const GREEN: &str = "\x1b[32m";
            pub const RESET: &str = "\x1b[0m";
        }

        fn is_covered(path: &Path) -> bool {
            let path_str = path.to_string_lossy();
            COVERED_PATHS.iter().any(|&p| path_str == p || path_str.starts_with(&format!("{p}/")))
        }

        fn walk_files(dir: &Path) -> impl Iterator<Item = std::path::PathBuf> + '_ {
            fs::read_dir(dir).into_iter().flatten().flatten().flat_map(|e| {
                let path = e.path();
                let meta = fs::symlink_metadata(&path).ok();
                match meta {
                    Some(m) if m.is_file() => vec![path],
                    Some(m) if m.is_dir() => walk_files(&path).collect(),
                    _ => vec![],
                }
            })
        }

        fn human_size(bytes: u64) -> String {
            const UNITS: &[(u64, &str)] = &[(1 << 30, "G"), (1 << 20, "M"), (1 << 10, "K")];
            UNITS
                .iter()
                .find(|(threshold, _)| bytes >= *threshold)
                .map(|(threshold, unit)| format!("{:.1}{unit}", bytes as f64 / *threshold as f64))
                .unwrap_or_else(|| format!("{bytes}B"))
        }

        fn dir_size(path: &Path) -> u64 {
            walk_files(path).filter_map(|p| fs::metadata(p).ok()).map(|m| m.len()).sum()
        }

        fn main() -> ExitCode {
            use std::io::Write;
            let stderr = std::io::stderr();

            let etc_untracked: Vec<_> = walk_files(Path::new("/etc"))
                .filter(|p| !is_covered(p))
                .collect();

            let varlib_untracked: Vec<_> = fs::read_dir("/var/lib")
                .into_iter()
                .flatten()
                .flatten()
                .map(|e| e.path())
                .filter(|p| p.is_dir() && !is_covered(p))
                .map(|p| (human_size(dir_size(&p)), p))
                .collect();

            let has_untracked = !etc_untracked.is_empty() || !varlib_untracked.is_empty();

            if !etc_untracked.is_empty() {
                let _ = writeln!(stderr.lock(), "{}=== Untracked files in /etc ==={}", color::YELLOW, color::RESET);
                etc_untracked.iter().for_each(|f| { let _ = writeln!(stderr.lock(), "  {}", f.display()); });
                let _ = writeln!(stderr.lock());
            }

            if !varlib_untracked.is_empty() {
                let _ = writeln!(stderr.lock(), "{}=== Untracked directories in /var/lib ==={}", color::YELLOW, color::RESET);
                varlib_untracked.iter().for_each(|(size, p)| { let _ = writeln!(stderr.lock(), "  {} ({size})", p.display()); });
                let _ = writeln!(stderr.lock());
            }

            if has_untracked {
                let _ = writeln!(stderr.lock(), "{}Untracked state found!{} Add to the responsible module's impermanence config.", color::RED, color::RESET);
                ExitCode::FAILURE
            } else {
                let _ = writeln!(stderr.lock(), "{}All state accounted for.{}", color::GREEN, color::RESET);
                ExitCode::SUCCESS
            }
        }
      '';
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      options.impermanence = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable impermanence with Btrfs rollback.";
        };

        persistPath = lib.mkOption {
          type = lib.types.str;
          default = "/persist";
          description = "Path where persistent state is stored.";
        };

        wipeOnBoot = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Whether to automatically wipe root on boot.
            When false, impermanence is configured but root is not wiped.
            Enable this only after verifying all needed state is persisted.
          '';
        };

        persistedFiles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Files to persist across reboots.";
        };

        persistedDirectories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Directories to persist across reboots.";
        };

        ignoredPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Paths that are safe to lose (generated on boot, caches, etc).";
        };
      };

      config = lib.mkIf cfg.enable {
        # Universal files that should be persisted on all systems
        impermanence.persistedFiles = [
          "/etc/machine-id"
          "/etc/adjtime"
        ];

        # Universal directories - nixos uid/gid state
        impermanence.persistedDirectories = [
          "/var/lib/nixos"
        ];

        # Paths generated by NixOS activation or safe to lose
        impermanence.ignoredPaths = [
          # /etc - generated by NixOS activation
          "/etc/NIXOS"
          "/etc/.clean"
          "/etc/.updated"
          "/etc/.pwd.lock"
          "/etc/passwd"
          "/etc/group"
          "/etc/shadow"
          "/etc/subuid"
          "/etc/subgid"
          "/etc/sudoers"
          "/etc/resolv.conf"
          "/etc/resolv.conf.bak"
          "/etc/kernel/entry-token"
          "/etc/nixos"
          # /var/lib/systemd - we persist specific subdirs, ignore the rest
          "/var/lib/systemd"
          # /var/lib - caches and regenerable state
          "/var/lib/AccountsService"
          "/var/lib/lastlog"
          "/var/lib/logrotate.status"
          "/var/lib/misc"
          "/var/lib/machines"
          "/var/lib/portables"
          "/var/lib/private"
          # Other ephemeral locations
          "/var/cache"
          "/root"
          "/srv"
          "/tmp"
          "/var/tmp"
        ];

        # Configure the impermanence module
        environment.persistence.${cfg.persistPath} = {
          hideMounts = true;
          files = cfg.persistedFiles;
          directories = cfg.persistedDirectories;
        };

        # Make the diff script available system-wide
        environment.systemPackages = [ impermanence-diff ];

        # Bootstrap: ensure persisted files exist in /persist and remove originals
        # so impermanence can create bind mounts. This runs before other activation scripts.
        system.activationScripts.impermanence-bootstrap = {
          text = ''
            echo "=== Impermanence Bootstrap ==="
            ${lib.concatMapStringsSep "\n" (file: ''
              # If file exists at original location but not in persist, copy it
              if [[ -e "${file}" && ! -L "${file}" && ! -e "${cfg.persistPath}${file}" ]]; then
                echo "Copying ${file} -> ${cfg.persistPath}${file}"
                mkdir -p "$(dirname "${cfg.persistPath}${file}")"
                cp -a "${file}" "${cfg.persistPath}${file}"
              fi
              # Remove original file (if not already a symlink/mount) so bind mount can be created
              if [[ -e "${file}" && ! -L "${file}" ]] && mountpoint -q "${file}" 2>/dev/null; then
                : # Already a mount point, leave it alone
              elif [[ -f "${file}" && ! -L "${file}" && -e "${cfg.persistPath}${file}" ]]; then
                echo "Removing ${file} to allow bind mount"
                rm -f "${file}"
              fi
            '') cfg.persistedFiles}
            echo "=== Bootstrap complete ==="
          '';
          deps = [ ];
        };

        # Post-rebuild activation script to warn about untracked state
        # Runs after other scripts via deps on "usrbinenv" (one of the last standard scripts)
        # Output goes to stderr so nh displays it (like sops does)
        system.activationScripts.impermanence-check = {
          text = ''
            ${impermanence-diff}/bin/impermanence-diff
          '';
          deps = [ "usrbinenv" ];
        };

        # Btrfs rollback on boot (only if wipeOnBoot is enabled)
        boot.initrd.systemd.services.rollback = lib.mkIf cfg.wipeOnBoot {
          description = "Rollback root filesystem to blank snapshot";
          wantedBy = [ "initrd.target" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt
            mount -o subvol=/ /dev/disk/by-label/NIXOS /mnt

            # Keep a backup of the old root
            if [[ -e /mnt/@root ]]; then
              timestamp=$(date +%Y%m%d-%H%M%S)
              mv /mnt/@root /mnt/@root-old-$timestamp
            fi

            # Delete old backups, keep last 3
            for old in $(ls -1d /mnt/@root-old-* 2>/dev/null | sort -r | tail -n +4); do
              btrfs subvolume delete "$old"
            done

            # Create fresh root from blank snapshot
            btrfs subvolume snapshot /mnt/@root-blank /mnt/@root

            umount /mnt
          '';
        };
      };
    };
}
