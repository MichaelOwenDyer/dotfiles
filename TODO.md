# TODO

Tracking improvements, bugfixes, and planned features for this configuration.

---

## Bugfixes

- [ ] VSCode complains on first startup about authentication with the OS keyring not matching
- [ ] OS keyring does not match login password - investigate root cause
- [ ] Caffeine doesn't show up in system tray

---

## Improvements

- [ ] Replace fuzzel with built-in niri dms window switcher / launcher
- [ ] Unify lock screen and auto lock on idle with dms

---

## Code Quality

### High Priority

- [ ] **Secrets management** - Hashed password is stored in git (`modules/users/michael/nixos.nix`)
  - Implement `agenix` or `sops-nix` for encrypted secrets

### Low Priority

- [ ] Add comments to uncommented modules for consistency

---

## Infrastructure

- [x] **CI/CD with GitHub Actions** (2026-01-24)
  - Format checking with `nixfmt`
  - Build validation for all hosts (dry-run)
  - Flake check on PRs
- [ ] **NixOS tests** for critical configurations

---

## Features to Add

### Applications

- [ ] [Vencord/Nixcord](https://github.com/KaylorBen/nixcord) - Discord client
- [ ] [Rclone](https://wiki.nixos.org/wiki/Rclone) - Cloud storage sync

### Architecture

- [x] **Distributed builds** - Builder module for rustbucket/mac, client module for claptrap/rpi-3b (2026-01-19)
- [ ] **Disko** - Declarative disk partitioning
- [ ] **Impermanence** - Stateless root filesystem
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
