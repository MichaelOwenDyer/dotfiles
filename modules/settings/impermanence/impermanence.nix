{
  inputs,
  lib,
  ...
}:
{
  # Impermanence - persist only explicitly declared state
  # https://github.com/nix-community/impermanence
  #
  # Service modules declare persistence needs via: impermanence.persistedDirectories = [ ... ];
  # Options defined in ./options.nix so they're available even when this module isn't imported.
  #
  # Status semantics: persisted (●), ephemeral (•), untracked (!), separate_mount (no icon)
  # Parent dirs bubble up: untracked > persisted > ephemeral

  flake.modules.nixos.impermanence =
    { config, pkgs, ... }:
    let
      cfg = config.impermanence;

      # Real mount points (not /, virtual fs, or bind mounts) - survive root rollback
      separateMounts = lib.pipe config.fileSystems [
        (lib.filterAttrs (
          path: fs:
          path != "/"
          && fs.fsType != "tmpfs"
          && fs.fsType != "proc"
          && fs.fsType != "sysfs"
          && fs.fsType != "devtmpfs"
          && fs.fsType != "devpts"
          && fs.fsType != "cgroup"
          && fs.fsType != "cgroup2"
          && fs.fsType != "securityfs"
          && fs.fsType != "debugfs"
          && fs.fsType != "configfs"
          && fs.fsType != "fusectl"
          && fs.fsType != "hugetlbfs"
          && fs.fsType != "mqueue"
          && fs.fsType != "pstore"
          && fs.fsType != "efivarfs"
          && fs.fsType != "bpf"
          && fs.fsType != "autofs"
          && fs.fsType != "fuse.portal"
          && !(lib.any (opt: opt == "bind" || lib.hasPrefix "bind," opt) (fs.options or [ ]))
        ))
        builtins.attrNames
        (builtins.sort (a: b: a < b))
      ];

      persistedFilesRust = lib.concatMapStringsSep ", " (f: ''"${f}"'') cfg.persistedFiles;
      persistedDirsRust = lib.concatMapStringsSep ", " (d: ''"${d}"'') cfg.persistedDirectories;
      ephemeralPathsRust = lib.concatMapStringsSep ", " (p: ''"${p}"'') cfg.ephemeralPaths;
      separateMountsRust = lib.concatMapStringsSep ", " (m: ''"${m}"'') separateMounts;

      pathsJson = builtins.toJSON {
        persist = { path = cfg.persistPath; files = cfg.persistedFiles; directories = cfg.persistedDirectories; };
        ephemeral = cfg.ephemeralPaths;
        separateMounts = separateMounts;
      };

      impermanence-diff = pkgs.writers.writeRustBin "impermanence-diff" { } ''
        use std::{env, fs, path::Path, process::ExitCode};

        const PERSISTED_FILES: &[&str] = &[${persistedFilesRust}];
        const PERSISTED_DIRS: &[&str] = &[${persistedDirsRust}];
        const EPHEMERAL_PATHS: &[&str] = &[${ephemeralPathsRust}];
        const SEPARATE_MOUNTS: &[&str] = &[${separateMountsRust}];

        mod color {
            pub const RED: &str = "\x1b[31m";
            pub const YELLOW: &str = "\x1b[33m";
            pub const GREEN: &str = "\x1b[32m";
            pub const CYAN: &str = "\x1b[36m";
            pub const DIM: &str = "\x1b[2m";
            pub const BOLD: &str = "\x1b[1m";
            pub const RESET: &str = "\x1b[0m";
        }

        #[derive(Clone, Copy, PartialEq)]
        enum Status { Persisted, Ephemeral, SeparateMount, Untracked }
        fn get_simple_status(path: &Path) -> Option<Status> {
            let s = path.to_string_lossy();
            // Check if on a separate mount
            for &m in SEPARATE_MOUNTS {
                if s == m || s.starts_with(&format!("{m}/")) { return Some(Status::SeparateMount); }
            }
            // Check if path is or is under a persisted path
            for &p in PERSISTED_FILES.iter().chain(PERSISTED_DIRS.iter()) {
                if s == p || s.starts_with(&format!("{p}/")) { return Some(Status::Persisted); }
            }
            // Check if path is or is under an ephemeral path
            for &p in EPHEMERAL_PATHS {
                if s == p || s.starts_with(&format!("{p}/")) { return Some(Status::Ephemeral); }
            }
            // Check if this is a parent of any configured path
            let has_configured_children = PERSISTED_FILES.iter()
                .chain(PERSISTED_DIRS.iter())
                .chain(EPHEMERAL_PATHS.iter())
                .any(|&p| p.starts_with(&format!("{s}/")));

            if has_configured_children {
                None // Needs scanning
            } else {
                Some(Status::Untracked)
            }
        }

        fn scan_directory_status(dir: &Path) -> Status {
            let mut has_persisted = false;
            if let Ok(entries) = fs::read_dir(dir) {
                for entry in entries.flatten() {
                    let path = entry.path();
                    let status = get_simple_status(&path).unwrap_or_else(||
                        if path.is_dir() { scan_directory_status(&path) } else { Status::Untracked }
                    );
                    match status {
                        Status::Untracked => return Status::Untracked,
                        Status::Persisted => has_persisted = true,
                        _ => {}
                    }
                }
            }
            if has_persisted { Status::Persisted } else { Status::Ephemeral }
        }

        fn get_status(path: &Path) -> Status {
            get_simple_status(path).unwrap_or_else(||
                if path.is_dir() { scan_directory_status(path) } else { Status::Untracked }
            )
        }

        fn walk(dir: &Path) -> Vec<std::path::PathBuf> {
            let mut out = Vec::new();
            if let Ok(entries) = fs::read_dir(dir) {
                for e in entries.flatten() {
                    let p = e.path();
                    if get_status(&p) == Status::SeparateMount { continue; }
                    if let Ok(m) = fs::symlink_metadata(&p) {
                        if m.is_file() || m.is_symlink() { out.push(p); }
                        else if m.is_dir() { out.extend(walk(&p)); }
                    }
                }
            }
            out
        }

        fn human_size(b: u64) -> String {
            const U: &[(u64, &str)] = &[(1<<30,"G"),(1<<20,"M"),(1<<10,"K")];
            U.iter().find(|(t,_)| b >= *t)
                .map(|(t,u)| format!("{:.1}{u}", b as f64 / *t as f64))
                .unwrap_or_else(|| format!("{b}B"))
        }

        fn dir_size(p: &Path) -> u64 {
            walk(p).iter().filter_map(|p| fs::metadata(p).ok()).map(|m| m.len()).sum()
        }

        fn main() -> ExitCode {
            use std::io::Write;
            let args: Vec<_> = env::args().collect();
            let verbose = args.iter().any(|a| a == "-v" || a == "--verbose");
            let show_all = args.iter().any(|a| a == "-a" || a == "--all");
            let help = args.iter().any(|a| a == "-h" || a == "--help");

            if help {
                eprintln!("Usage: impermanence-diff [OPTIONS]");
                eprintln!();
                eprintln!("Check for untracked state on the root filesystem.");
                eprintln!();
                eprintln!("Options:");
                eprintln!("  -v, --verbose  Show all paths with their status");
                eprintln!("  -a, --all      Show configuration summary");
                eprintln!("  -h, --help     Show this help");
                return ExitCode::SUCCESS;
            }

            let out = std::io::stderr();

            // Show config summary with --all
            if show_all {
                let _ = writeln!(out.lock(), "{}{}Impermanence Configuration{}", color::BOLD, color::CYAN, color::RESET);
                let _ = writeln!(out.lock(), "{}Mounts (outside scope):{} {}", color::DIM, color::RESET,
                    SEPARATE_MOUNTS.iter().map(|s| s.to_string()).collect::<Vec<_>>().join(" "));
                let _ = writeln!(out.lock(), "{}Persisted files:{} {}", color::DIM, color::RESET, PERSISTED_FILES.len());
                let _ = writeln!(out.lock(), "{}Persisted dirs:{} {}", color::DIM, color::RESET, PERSISTED_DIRS.len());
                let _ = writeln!(out.lock(), "{}Ephemeral paths:{} {}", color::DIM, color::RESET, EPHEMERAL_PATHS.len());
                let _ = writeln!(out.lock());
            }

            // Counts from configuration (not runtime)
            let n_mounts = SEPARATE_MOUNTS.len();
            let n_persisted = PERSISTED_FILES.len() + PERSISTED_DIRS.len();
            let n_ephemeral = EPHEMERAL_PATHS.len();

            // Collect all top-level paths on root filesystem for scanning
            let root_entries: Vec<_> = fs::read_dir("/").into_iter().flatten().flatten()
                .map(|e| e.path())
                .filter(|p| {
                    let n = p.file_name().and_then(|n| n.to_str()).unwrap_or("");
                    !["proc", "sys", "dev", "run"].contains(&n) && p.exists()
                })
                .collect();

            // Collect untracked top-level paths
            let mut untracked: Vec<(String, std::path::PathBuf)> = Vec::new();

            if verbose {
                let _ = writeln!(out.lock(), "{}Root filesystem contents:{}", color::DIM, color::RESET);
                for entry in &root_entries {
                    let status = get_status(entry);
                    // ● persisted, • ephemeral, ! untracked, (nothing) separate mount
                    let (icon, col) = match status {
                        Status::Persisted => ("●", color::CYAN),
                        Status::Ephemeral => ("•", color::DIM),
                        Status::Untracked => ("!", color::RED),
                        Status::SeparateMount => (" ", color::RESET),
                    };
                    let _ = writeln!(out.lock(), "  {}{} {}{}", col, icon, entry.display(), color::RESET);
                }
                let _ = writeln!(out.lock());
            }

            // Find untracked top-level entries
            for entry in &root_entries {
                let status = get_status(entry);
                if status == Status::Untracked {
                    let name = entry.file_name().and_then(|n| n.to_str()).unwrap_or("");
                    if !["etc", "var"].contains(&name) {
                        let sz = if entry.is_dir() { dir_size(entry) } else {
                            fs::metadata(entry).map(|m| m.len()).unwrap_or(0)
                        };
                        untracked.push((human_size(sz), entry.clone()));
                    }
                }
            }

            // Scan /etc and /var deeper
            let etc_untracked: Vec<_> = walk(Path::new("/etc")).into_iter()
                .filter(|p| get_status(p) == Status::Untracked).collect();

            let var_untracked: Vec<_> = fs::read_dir("/var").into_iter().flatten().flatten()
                .map(|e| e.path())
                .filter(|p| p.is_dir() && get_status(p) != Status::SeparateMount)
                .flat_map(|sub| {
                    if sub == Path::new("/var/lib") {
                        fs::read_dir(&sub).into_iter().flatten().flatten()
                            .map(|e| e.path())
                            .filter(|p| p.is_dir() && get_status(p) == Status::Untracked)
                            .collect::<Vec<_>>()
                    } else if get_status(&sub) == Status::Untracked {
                        vec![sub]
                    } else { vec![] }
                })
                .map(|p| (human_size(dir_size(&p)), p))
                .collect();

            let total_untracked = etc_untracked.len() + var_untracked.len() + untracked.len();

            // Compact output - matching yazi plugin icons
            // ● persisted, • ephemeral, ! untracked, (nothing) separate mount
            let _ = write!(out.lock(), "impermanence: ");
            let _ = write!(out.lock(), "{} mounts  ", n_mounts);
            let _ = write!(out.lock(), "{}●{} {} persisted  ", color::CYAN, color::RESET, n_persisted);
            let _ = write!(out.lock(), "{}•{} {} ephemeral  ", color::DIM, color::RESET, n_ephemeral);
            if total_untracked > 0 {
                let _ = write!(out.lock(), "{}!{} {} untracked", color::RED, color::RESET, total_untracked);
            } else {
                let _ = write!(out.lock(), "{}✓{}", color::GREEN, color::RESET);
            }
            let _ = writeln!(out.lock());

            // Show untracked details
            if total_untracked > 0 {
                if !etc_untracked.is_empty() {
                    let _ = writeln!(out.lock(), "{}⚠ /etc ({} files):{} {}",
                        color::YELLOW, etc_untracked.len(), color::RESET,
                        if verbose || etc_untracked.len() <= 5 {
                            etc_untracked.iter().map(|p| p.file_name().and_then(|n| n.to_str()).unwrap_or("?")).collect::<Vec<_>>().join(" ")
                        } else {
                            format!("{} ... (use -v to see all)", etc_untracked.iter().take(3).map(|p| p.file_name().and_then(|n| n.to_str()).unwrap_or("?")).collect::<Vec<_>>().join(" "))
                        });
                }
                if !var_untracked.is_empty() {
                    let _ = writeln!(out.lock(), "{}⚠ /var ({}):{} {}",
                        color::YELLOW, var_untracked.len(), color::RESET,
                        var_untracked.iter().map(|(sz,p)| format!("{}({})", p.file_name().and_then(|n| n.to_str()).unwrap_or("?"), sz)).collect::<Vec<_>>().join(" "));
                }
                if !untracked.is_empty() {
                    let _ = writeln!(out.lock(), "{}⚠ / ({}):{} {}",
                        color::YELLOW, untracked.len(), color::RESET,
                        untracked.iter().map(|(sz,p)| format!("{}({})", p.file_name().and_then(|n| n.to_str()).unwrap_or("?"), sz)).collect::<Vec<_>>().join(" "));
                }
                let _ = writeln!(out.lock(), "{}Add to persistedDirectories or ephemeralPaths{}", color::DIM, color::RESET);
                ExitCode::FAILURE
            } else {
                ExitCode::SUCCESS
            }
        }
      '';
    in
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      options.impermanence = {
        persistPath = lib.mkOption {
          type = lib.types.str;
          default = "/persist";
          description = "Path for persistent state.";
        };

        wipeOnBoot = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Wipe root on boot (enable after verifying persistence).";
        };
      };

      config = {
        impermanence.enable = lib.mkDefault true;
        impermanence.persistedFiles = [ "/etc/machine-id" "/etc/adjtime" ];
        impermanence.persistedDirectories = [ "/var/lib/nixos" ];

        # Core NixOS paths - always regenerated by activation scripts
        # Feature-specific paths are declared in their respective modules:
        #   locale.nix, nix-settings.nix, security.nix, etc.
        impermanence.ephemeralPaths = [
          # NixOS markers and locks
          "/etc/NIXOS"
          "/etc/.clean"
          "/etc/.updated"
          "/etc/.pwd.lock"

          # User/group databases (regenerated from declarative config)
          "/etc/passwd"
          "/etc/group"
          "/etc/shadow"
          "/etc/subuid"
          "/etc/subgid"
          "/etc/sudoers"
          "/etc/login.defs"

          # Generated by this module
          "/etc/impermanence-paths.json"

          # Filesystem tables
          "/etc/fstab"
          "/etc/mtab"

          # Hostname and network identity
          "/etc/hostname"
          "/etc/hosts"
          "/etc/host.conf"

          # OS identification
          "/etc/os-release"
          "/etc/lsb-release"
          "/etc/issue"

          # Shell environment (bash-specific paths in bash.nix)
          "/etc/profile"
          "/etc/set-environment"
          "/etc/shells"

          # Network services database
          "/etc/protocols"
          "/etc/services"
          "/etc/rpc"
          "/etc/netgroup"
          "/etc/gai.conf"
          "/etc/nscd.conf"
          "/etc/nsswitch.conf"

          # Systemd and init
          "/etc/systemd"
          "/etc/tmpfiles.d"
          "/etc/binfmt.d"
          "/etc/modprobe.d"
          "/etc/modules-load.d"
          "/etc/sysctl.d"
          "/etc/udev"
          "/etc/default"

          # Documentation
          "/etc/man_db.conf"
          "/etc/terminfo"

          # /var - runtime state
          "/var/.updated"
          "/var/cache"
          "/var/db"
          "/var/empty"
          "/var/lock"
          "/var/run"
          "/var/spool"
          "/var/tmp"

          # /var/lib - ephemeral service state
          "/var/lib/AccountsService"
          "/var/lib/lastlog"
          "/var/lib/logrotate.status"
          "/var/lib/machines"
          "/var/lib/misc"
          "/var/lib/portables"
          "/var/lib/private"
          "/var/lib/systemd"

          # Top-level directories (NixOS shims or empty mount points)
          "/bin"
          "/lib64"
          "/usr"
          "/mnt"
          "/root" # Root home - ephemeral (persist specific files if needed)
          "/srv"
          "/tmp"
        ];

        environment.persistence.${cfg.persistPath} = { hideMounts = true; files = cfg.persistedFiles; directories = cfg.persistedDirectories; };
        environment.systemPackages = [ impermanence-diff ];
        environment.etc."impermanence-paths.json".text = pathsJson;

        # Bootstrap: copy files to /persist and remove originals for bind mounts
        system.activationScripts.impermanence-bootstrap = {
          text = ''
            echo "=== Impermanence Bootstrap ==="
            ${lib.concatMapStringsSep "\n" (file: ''
              if [[ -e "${file}" && ! -L "${file}" && ! -e "${cfg.persistPath}${file}" ]]; then
                echo "Copying ${file} -> ${cfg.persistPath}${file}"
                mkdir -p "$(dirname "${cfg.persistPath}${file}")"
                cp -a "${file}" "${cfg.persistPath}${file}"
              fi
              if [[ -f "${file}" && ! -L "${file}" && -e "${cfg.persistPath}${file}" ]] && ! mountpoint -q "${file}" 2>/dev/null; then
                echo "Removing ${file} to allow bind mount"
                rm -f "${file}"
              fi
            '') cfg.persistedFiles}
            echo "=== Bootstrap complete ==="
          '';
          deps = [ ];
        };

        system.activationScripts.impermanence-check = {
          text = "${impermanence-diff}/bin/impermanence-diff || true";
          deps = [ "usrbinenv" ];
        };

        boot.initrd.systemd.services.rollback = lib.mkIf cfg.wipeOnBoot {
          description = "Rollback root to blank snapshot";
          wantedBy = [ "initrd.target" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt && mount -o subvol=/ /dev/disk/by-label/NIXOS /mnt
            [[ -e /mnt/@root ]] && mv /mnt/@root /mnt/@root-old-$(date +%Y%m%d-%H%M%S)
            for old in $(ls -1d /mnt/@root-old-* 2>/dev/null | sort -r | tail -n +4); do btrfs subvolume delete "$old"; done
            btrfs subvolume snapshot /mnt/@root-blank /mnt/@root && umount /mnt
          '';
        };
      };
    };
}
