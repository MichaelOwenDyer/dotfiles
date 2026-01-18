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

- [ ] **Split large niri module** - 457 lines is unwieldy
  - Consider: `niri/{base,keybinds,appearance,window-rules}.nix`
- [ ] **Integrate theming with stylix** - Niri has hardcoded Catppuccin colors
  - Location: `modules/features/window-manager/niri/niri.nix`

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
  - `1password.nix`, `desktop.nix`, `rustbucket/hardware.nix`, `rustbucket.nix`
  - `cursor.nix`, `chrome.nix`, `hyprland.nix`, `vscode.nix`
  - `audio.nix`, `wifi.nix`, `ssh.nix`
- [x] Add `default-settings` to rpi-3b configuration (2026-01-19)
