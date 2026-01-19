# TODO

Tracking improvements, bugfixes, and planned features for this configuration.

---

## Bugfixes

- [ ] VSCode complains on first startup about authentication with the OS keyring not matching
- [ ] Caffeine doesn't show up in system tray

---

## Code Quality

### High Priority

- [ ] **Secrets management** - Hashed password is stored in git (`modules/users/michael/nixos.nix`)
  - Implement `agenix` or `sops-nix` for encrypted secrets

### Medium Priority

- [ ] **Integrate theming with stylix** - Niri has hardcoded Catppuccin colors
  - Location: `modules/features/window-manager/niri/appearance.nix`

### Low Priority

- [ ] Add comments to uncommented modules for consistency

---

## Infrastructure

- [ ] **CI/CD with GitHub Actions**
  - Format checking with `nixfmt` or `alejandra`
  - Build validation for all hosts
  - Flake check on PRs
- [ ] **NixOS tests** for critical configurations

---

## Features to Add

### Applications

- [ ] [Vencord/Nixcord](https://github.com/KaylorBen/nixcord) - Discord client
- [ ] [Rclone](https://wiki.nixos.org/wiki/Rclone) - Cloud storage sync

### Architecture

- [ ] **Distributed builds** - Builder module for rustbucket/mac, client module for claptrap/rpi-3b
- [ ] **Disko** - Declarative disk partitioning
- [ ] **Impermanence** - Stateless root filesystem
- [ ] **Custom module options** - e.g., `options.my.development.enable`
- [ ] **Roles abstraction** - `workstation`, `server`, `gaming` presets

---

## Dependency Maintenance

- [ ] Review `niri-flake` not following nixpkgs (potential version mismatch)
- [ ] Consider lazy evaluation for `pkgs.stable`/`pkgs.master` to reduce build time

---

## Completed

- [x] Update README to reflect current directory structure (2026-01-19)
- [x] Fix hardcoded `/home/user/.steam` path in gaming module (2026-01-19)
- [x] Remove unused parameters from modules (2026-01-19)
  - Batch 1: `1password.nix`, `desktop.nix`, `rustbucket/hardware.nix`, `rustbucket.nix`, `cursor.nix`, `chrome.nix`, `hyprland.nix`, `vscode.nix`, `audio.nix`, `wifi.nix`, `ssh.nix`
  - Batch 2: `noctalia.nix`, `firefox.nix`, `gnome-keyring.nix`, `zsh.nix`, `stylix-config.nix`, `plymouth.nix`
- [x] Add `default-settings` to rpi-3b configuration (2026-01-19)
- [x] Remove duplicate `home-manager` import from rustbucket (2026-01-19)
- [x] Remove redundant `console.font` from claptrap and rustbucket (2026-01-19)
- [x] Split niri module into `niri.nix`, `input.nix`, `appearance.nix`, `keybinds.nix` (2026-01-19)
- [x] Fix yazi config error: use `theme.flavor` instead of manual xdg config file (2026-01-19)
- [x] Fix helix config error: move keybinds from `extraConfig` to `settings.keys` (2026-01-19)
