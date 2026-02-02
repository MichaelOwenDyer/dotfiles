# TODO

Tracking improvements, bugfixes, and planned features for this configuration.

---

## Bugfixes

- [x] VSCode complains on first startup about authentication with the OS keyring not matching (2026-01-24)
  - Added PAM integration for `ly` display manager in `gnome-keyring.nix`
  - Added `passwd` PAM service for automatic keyring password sync
  - Added `gnome-keyring-daemon --start --components=secrets` to niri startup
- [x] OS keyring does not match login password - investigate root cause (2026-01-24)
  - Root cause: keyring created with different password than login password
  - Fix: delete `~/.local/share/keyrings/login.keyring` and re-login to recreate with correct password
- [ ] Caffeine doesn't show up in system tray
- [ ] `network-setup.service` fails on boot due to race condition (interface not up yet)
  - Affects `local-streaming-network` module on rustbucket
  - Networking still works via NetworkManager, but service shows failed

---

## Improvements

### Niri & DMS

- [x] **Update DMS for 1.2** - Using flake directly with `programs.dank-material-shell` (2026-01-24)
- [x] **Enable DMS niri integration** - `programs.dank-material-shell.niri.includes` configured (2026-01-24)
- [x] **Replace fuzzel with DMS launcher** - Using DMS built-in launcher (2026-01-24)
- [x] **Configure lock screen and idle** - Unify with DMS lock screen features, make screen turn off automatically and lock
- [x] **Configure Niri displays per-host** - Separate output modules for claptrap/rustbucket
- [ ] **Investigate DMS plugins** - Review available plugins in registry

### AdGuard Home

- [ ] **Migrate AdGuard Home to rpi-3b** - Currently running on rustbucket as temporary solution
  - On rpi-3b: Enable DHCP server (single interface, dedicated device)
  - On rpi-3b: Pi handles both DNS and DHCP for home network
  - Disable router's DHCP, let Pi manage it
  - Better client identification when DHCP + DNS on same device
- [ ] **Configure router DNS to point to AdGuard Home** - Until rpi-3b migration
  - Set router's DNS server to rustbucket (192.168.0.1)
  - Router keeps DHCP for now (AdGuard Home DHCP conflicts with rustbucket's multi-interface setup)
- [ ] **Tune AdGuard Home settings** - Evaluate and declare preferred config
  - Upstream DNS (DoH/DoT providers)
  - DNSSEC, caching settings
  - Filter lists
  - Set `mutableSettings = false` once config is finalized

### IPv6

- [ ] **Investigate and enable IPv6 on home network**
  - **Current state**: No global IPv6 addresses on any host. Only link-local (`fe80::`) and ULA (`fd*`) addresses present.
  - **Likely cause**: Router (M-Net fiber) is probably receiving IPv6 from ISP but not delegating prefixes to LAN.
  - **Router settings to check**:
    - IPv6 / DHCPv6 enabled
    - Prefix Delegation (PD) enabled
    - Router Advertisement (RA) enabled
  - **How to verify when working**: `ip -6 addr show scope global` should show `2001:` or `2a02:` addresses; `curl -6 ifconfig.me` should return your public IPv6
  - **Potential benefits once working**:
    - Direct connectivity between home devices without NAT
    - Could bypass Tailscale for home-to-home connections (lower latency)
    - Future-proofing as IPv4 becomes scarcer
  - **Note**: Tailscale still valuable for remote access and when away from home. IPv6 is nice-to-have, not essential given current Tailscale setup works well.
  - **Data already in place**: `hosts-registry.nix` already has Tailscale IPv6 addresses (`fd7a:115c:a1e0::*`) and streaming network IPv6 prefix (`fdc9:1a4b:53e1:50::`). Once router IPv6 is fixed, can add global addresses.

### Other

- [ ] **Configure router with Nix** - Replace imperative router configuration with declarative NixOS setup
- [ ] **Fix TV output requiring HDMI replug** - TV output stops working after being off or displaying something else for a while
- [ ] **Re-add Windows 10 to rustbucket's boot menu** - Rustbucket is dual-boot, Windows boot entry disappeared at some point

---

## Code Quality

### High Priority

- [x] **Secrets management** - sops-nix for encrypted secrets (2026-01-25)
  - User password hash now encrypted in `modules/settings/secrets/secrets.yaml`
  - Host SSH keys used for decryption (no separate admin key needed)
  - To add a new host: get its age key, add to `.sops.yaml`, run `sops updatekeys secrets.yaml`

### Low Priority

- [ ] Add comments to uncommented modules for consistency
- [ ] **Migrate to keys-registry** - Replace `sshKeys` usages with `keys.ssh.*` and remove legacy compat layer
- [ ] **Enable keys-deployment** - Wire up hosts to deploy keys from sops at boot
- [x] Rewrite `impermanence-diff` in Rust (bash script has output issues) (2026-01-25)

---

## Infrastructure

- [x] **CI/CD with GitHub Actions** (2026-01-24)
  - Build validation for all hosts (dry-run)
  - Flake check on PRs
- [ ] **NixOS tests** for critical configurations

---

## Features to Add

### Applications

- [ ] [Vencord/Nixcord](https://github.com/KaylorBen/nixcord) - Discord client
- [ ] [Rclone](https://wiki.nixos.org/wiki/Rclone) - Cloud storage sync
- [ ] **Enable ollama server for local and remote use, integrate cursor-cli if possible** - Local AI services

### Architecture

- [x] **Distributed builds** - Builder module for rustbucket/mac, client module for claptrap/rpi-3b (2026-01-19)
- [ ] **Disko** - Declarative disk partitioning
- [x] **Impermanence** - Stateless root filesystem (2026-01-25)
  - Root wiped on every boot via Btrfs snapshot rollback
  - Persistence declared per-module using `lib.mkIf (config ? impermanence)` pattern
  - `impermanence-diff` script to audit untracked state
  - Bootstrap script auto-copies files to `/persist` on first activation
- [ ] **Custom module options** - e.g., `options.my.development.enable`
- [ ] **Roles abstraction** - `workstation`, `server`, `gaming` presets

---

## Dependency Maintenance

- [ ] Periodically run `nix flake update` to keep inputs current

---

## Completed

- [x] Update README to reflect current directory structure (2026-01-19)
- [x] Fix hardcoded `/home/user/.steam` path in gaming module (2026-01-19)
- [x] Remove unused parameters from modules (2026-01-19)
  - Batch 1: `1password.nix`, `desktop.nix`, `rustbucket/hardware.nix`, `rustbucket.nix`, `cursor.nix`, `chrome.nix`, `hyprland.nix`, `vscode.nix`, `audio.nix`, `wifi.nix`, `ssh.nix`
  - Batch 2: `noctalia.nix`, `firefox.nix`, `gnome-keyring.nix`, `zsh.nix`, `plymouth.nix`
- [x] Add `default-settings` to rpi-3b configuration (2026-01-19)
- [x] Remove duplicate `home-manager` import from rustbucket (2026-01-19)
- [x] Remove redundant `console.font` from claptrap and rustbucket (2026-01-19)
- [x] Split niri module into `niri.nix`, `input.nix`, `appearance.nix`, `keybinds.nix` (2026-01-19)
- [x] Fix yazi config error: use `theme.flavor` instead of manual xdg config file (2026-01-19)
- [x] Fix helix config error: move keybinds from `extraConfig` to `settings.keys` (2026-01-19)
- [x] Remove redundant `home.sessionVariables.EDITOR` from helix (defaultEditor handles it) (2026-01-19)
- [x] Fix EDITOR not set to hx - use `systemd.user.sessionVariables` for graphical session (2026-01-19)
- [x] Switch vscode rust-analyzer from `pkgs.stable` to unstable (2026-01-19)
- [x] Document niri-flake intentionally not following nixpkgs (uses own cache) (2026-01-19)
- [x] Document pkgs.stable/master availability and current usage status (2026-01-19)
- [x] Remove additional unused parameters from cli.nix and darwin.nix (2026-01-19)
- [x] Extract reusable modules from host configurations (2026-01-19)
  - `systemd-boot` - bootloader configuration
  - `keyboard-us` - US keyboard layout
  - `nvidia` - NVIDIA GPU driver
  - `podman` - container runtime with Docker compatibility
  - `hibernate` - suspend-then-hibernate power management
  - `touchpad` - libinput touchpad configuration
- [x] Opinionated enhancements across modules (2026-01-19)
  - `nixos-default`: nix gc, fwupd, inotify limits, flake registry settings
  - `ssh`: security hardening, fail2ban, modern key exchange algorithms
  - `systemd-boot`: silent boot, tmp cleanup, console mode
  - `nvidia`: hardware acceleration, wayland environment variables
  - `wifi`: systemd-resolved, iwd network configuration, mac randomization
  - `laptop`: TLP power management, thermald, battery charge thresholds
  - `git`: delta diffs, aliases, push defaults, rerere, histogram diff
  - `fish`: abbreviations, functions, additional plugins (done, colored-man-pages)
  - `helix`: comprehensive LSP setup, keybinds, editor settings, formatters
  - `ghostty`: theme, font, keybindings, shell integration
