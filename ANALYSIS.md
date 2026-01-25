# NixOS Dotfiles Configuration Analysis

**Analysis Date:** January 25, 2026  
**Analyzed by:** Claude (AI Code Review)

---

## Executive Summary

This is a well-architected, multi-host NixOS configuration using modern Nix patterns. The codebase demonstrates solid understanding of the Nix ecosystem with continuous improvements in modularity, security, and code quality. The "dendritic" pattern via `flake-file` and `import-tree` creates a clean, scalable architecture.

**Overall Quality Rating: A-**

*Rating improved from B+ due to: secrets management implementation, CI/CD pipeline, niri module split, custom module options, comprehensive documentation, and code quality improvements.*

---

## 1. Architecture Overview

### 1.1 Core Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| Flake Framework | `flake-parts` | Module-based flake structure |
| Auto-generation | `flake-file` | Generates `flake.nix` from modules |
| Module Discovery | `import-tree` | Recursive module importing |
| User Config | `home-manager` | Per-user configuration |
| Darwin Support | `nix-darwin` | macOS system configuration |
| Secrets | `sops-nix` | Encrypted secrets management |
| Theming | `stylix` | System-wide theming (available) |

### 1.2 Directory Structure

```
modules/
├── defaults/           # Base configurations (nixos, darwin, home-manager)
├── features/           # Application and tooling modules
│   ├── browser/        # Browser configurations (zen, firefox, chrome)
│   ├── development/    # Dev tools and shell aliases
│   ├── ide/            # Editor configurations (helix, cursor, vscode)
│   ├── nh/             # Nix helper CLI
│   ├── shell/          # Shell configurations (fish, zsh, nushell)
│   └── window-manager/ # WM configs (niri, gnome, hyprland, dank-material-shell)
├── hosts/              # Per-machine configurations
│   ├── claptrap/       # Dell XPS 13 laptop (x86_64-linux)
│   ├── rustbucket/     # Gaming PC with Nvidia (x86_64-linux)
│   ├── rpi-3b/         # Raspberry Pi 3B (aarch64-linux)
│   └── mac/            # macOS system (aarch64-darwin)
├── repositories/       # nixpkgs overlays and NUR
├── settings/           # System-level settings (audio, bluetooth, secrets, etc.)
│   ├── distributed-builds/  # Builder/client infrastructure
│   ├── local-streaming-network/  # Game streaming setup
│   ├── power-management/    # Hibernate, idle management
│   └── secrets/        # sops-nix encrypted secrets
├── users/              # User-specific configurations
└── lib.nix             # Helper functions (mkNixos, mkDarwin, mkHomeManager)
```

### 1.3 Module Composition Pattern

The configuration uses a **multi-context module pattern** where features define modules for multiple contexts (NixOS, Darwin, Home-Manager) in a single file:

```nix
# Example: modules/features/development/git.nix
{
  flake.modules.nixos.git = { ... };
  flake.modules.darwin.git = { ... };
  flake.modules.homeManager.git = { ... };
}
```

This approach:
- ✅ Keeps related configuration together
- ✅ Makes it easy to ensure feature parity across systems
- ✅ Uses custom module options for configurable features

---

## 2. Static Dependency Analysis

### 2.1 Flake Inputs (17 total)

| Input | Purpose | Follows nixpkgs? |
|-------|---------|------------------|
| `nixpkgs` | Primary package source (unstable) | - |
| `nixpkgs-stable` | Fallback packages (25.11) | No |
| `nixpkgs-master` | Early access packages | No |
| `nixpkgs-lib` | Library functions | Follows nixpkgs |
| `home-manager` | User configuration | ✅ Yes |
| `nix-darwin` | macOS support | ✅ Yes |
| `hardware` | Hardware quirks | No |
| `flake-parts` | Flake modules | Uses nixpkgs-lib |
| `flake-file` | Flake generation | No |
| `import-tree` | Module discovery | No |
| `nh` | Nix helper CLI | ✅ Yes |
| `niri-flake` | Niri window manager | No (intentional - uses own cache) |
| `nur` | User repository | ✅ Yes |
| `sops-nix` | Secrets management | ✅ Yes |
| `stylix` | Theming system | ✅ Yes |
| `systems` | System definitions | No |
| `zen-browser` | Zen browser (forked) | ✅ Yes |
| `noctalia` | Noctalia shell | ✅ Yes |
| `dank-material-shell` | Desktop shell | ✅ Yes |

### 2.2 Dependency Graph (Simplified)

```
flake.nix
├── flake-parts (module system)
├── flake-file (generates flake.nix)
├── import-tree (discovers modules)
│
├── SYSTEM LAYER
│   ├── nixpkgs (unstable) ─┬─ home-manager
│   │                       ├─ nix-darwin
│   │                       ├─ nh
│   │                       ├─ nur
│   │                       ├─ sops-nix
│   │                       ├─ stylix
│   │                       ├─ dank-material-shell
│   │                       └─ zen-browser
│   ├── nixpkgs-stable (25.11 fallback)
│   ├── nixpkgs-master (bleeding edge)
│   └── hardware (Dell XPS, etc.)
│
└── DESKTOP LAYER
    ├── niri-flake (own nixpkgs - uses upstream binary cache)
    └── noctalia (shell overlay)
```

### 2.3 Overlay Stack

Overlays are applied to both NixOS and Darwin:

1. **nixpkgs-stable/master access** (`pkgs.stable.*`, `pkgs.master.*`)
2. **NUR packages** (`pkgs.nur.*`)
3. **niri-flake overlay** (niri-unstable, niri-stable)
4. **nh overlay** (nh CLI tool)
5. **zen-browser overlay** (`pkgs.zen-browser`)
6. **dank-material-shell overlay** (DMS packages)

### 2.4 Dependency Notes

| Item | Status | Notes |
|------|--------|-------|
| `niri-flake` nixpkgs | ✅ Intentional | Uses own nixpkgs for upstream binary cache support |
| Triple nixpkgs evaluation | ℹ️ Documented | `stable`, `master`, and main all available via overlays |
| `hardware` not following | Low impact | Hardware quirks don't need version alignment |

---

## 3. Host Configuration Analysis

### 3.1 Host Matrix

| Host | Architecture | Type | Key Features |
|------|--------------|------|--------------|
| `claptrap` | x86_64-linux | Laptop | Dell XPS 13 9360, Niri, TLP, hibernate |
| `rustbucket` | x86_64-linux | Desktop | Nvidia GPU, Gaming, Steam, distributed build server |
| `rpi-3b` | aarch64-linux | Server | Minimal, SSH-only, headless |
| `mac` | aarch64-darwin | Workstation | Determinate Nix, Touch ID |

### 3.2 Module Import Chains

**claptrap (Laptop)**:
```
claptrap
├── claptrap-hardware (Dell XPS 13 9360 from nixos-hardware)
├── laptop → desktop → default-settings → overlays, nh, sops
│   └── touchpad, hibernate, TLP power management
├── podman (container runtime)
├── ly (display manager)
├── niri (window manager)
├── dank-material-shell
├── gnome-keyring
├── plymouth
├── ssh
└── michael-claptrap → michael (user)
```

**rustbucket (Gaming PC)**:
```
rustbucket
├── rustbucket-hardware
├── desktop → default-settings → overlays, nh, sops
├── nvidia (GPU drivers with hardware acceleration)
├── gaming (Steam, Wine, Lutris, etc.)
├── ly, niri, dank-material-shell, gnome-keyring, plymouth
├── ssh
├── distributed-build-server
├── local-streaming-network
└── michael-rustbucket → michael (user)
```

**rpi-3b (Raspberry Pi)**:
```
rpi-3b
├── default-settings → overlays, nh, sops
├── rpi-3b-hardware
├── ssh
└── michael-rpi-3b → michael (user)
```

### 3.3 Configuration Observations

**Strengths:**
- Clean separation of hardware-specific and feature modules
- Consistent use of `default-settings` base for all hosts
- Good use of `nixos-hardware` for Dell XPS quirks
- Host-specific niri output configurations (`claptrap/niri-outputs.nix`, `rustbucket/niri-outputs.nix`)
- Custom module options for complex features (distributed builds, local streaming)

---

## 4. Code Quality Assessment

### 4.1 Positive Patterns

| Pattern | Example | Assessment |
|---------|---------|------------|
| Multi-context modules | `git.nix`, `fish.nix`, `nushell.nix` | ✅ Excellent DRY approach |
| Helper functions | `lib.nix` with `mkNixos`, `mkDarwin` | ✅ Reduces boilerplate |
| Shell alias abstraction | `shell-alias/*.nix` | ✅ Composable, single responsibility |
| Flake input follows | Most inputs follow nixpkgs | ✅ Reduces duplication |
| SSH key management | Centralized in user module | ✅ Single source of truth |
| Feature bundling | `cli.nix`, `development.nix` | ✅ Good high-level abstractions |
| Module split | `niri/` split into input, appearance, keybinds | ✅ Improved maintainability |
| Custom options | `distributed-build.*`, `localStreaming.*` | ✅ Proper Nix module patterns |
| Secrets management | sops-nix with host SSH keys | ✅ No plaintext secrets in repo |

### 4.2 Recent Improvements (Since Last Analysis)

| Improvement | Status | Details |
|-------------|--------|---------|
| Secrets management | ✅ Implemented | sops-nix encrypts user password |
| CI/CD pipeline | ✅ Implemented | GitHub Actions with flake check and build validation |
| Niri module split | ✅ Completed | `niri.nix`, `input.nix`, `appearance.nix`, `keybinds.nix` |
| Gaming module fix | ✅ Fixed | Uses `$HOME` instead of hardcoded path |
| Unused parameters | ✅ Cleaned | Removed from 16+ modules |
| README updated | ✅ Updated | Reflects current directory structure |
| rpi-3b default-settings | ✅ Added | Now imports base configuration |
| Custom module options | ✅ Added | `distributed-build.*`, `localStreaming.*` |
| Nushell support | ✅ Added | Full nushell configuration with custom commands |

### 4.3 Remaining Issues

| Issue | Location | Severity | Recommendation |
|-------|----------|----------|----------------|
| Hardcoded theme colors | `niri/appearance.nix` | Low | Consider using Stylix for theming |
| Passwordless sudo | `rustbucket/configuration.nix` | Low | Documented as intentional for gaming machine |
| Some modules lack comments | Various | Low | Add documentation headers |

### 4.4 Code Style Consistency

**Consistent:**
- Import organization (alphabetical within groups)
- Use of `with inputs.self.modules.*` pattern
- Module structure follows established pattern
- Module headers with comments describing purpose

**Minor Inconsistencies:**
- Some files have detailed comments, others minimal
- Variable naming mostly consistent (`name` for display name)

---

## 5. Security Analysis

### 5.1 Current Security Posture

| Area | Status | Notes |
|------|--------|-------|
| SSH Configuration | ✅ Good | No root login, no password auth, fail2ban |
| Secrets Management | ✅ Good | sops-nix with age encryption |
| Sudo | ℹ️ Intentional | Passwordless on rustbucket (gaming convenience) |
| Firewall | ✅ Good | Uses nftables, trusted interfaces configured |
| Password Storage | ✅ Good | Hashed password encrypted in `secrets.yaml` |
| Key Management | ✅ Good | Host SSH keys used for secret decryption |

### 5.2 sops-nix Implementation

```nix
# Host SSH keys serve as age keys for decryption
sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
sops.defaultSopsFile = ./secrets.yaml;

# User password read from decrypted secret at activation
sops.secrets."michael-password".neededForUsers = true;
users.users.michael.hashedPasswordFile = config.sops.secrets."michael-password".path;
```

---

## 6. Best Practices Adherence

### 6.1 Nix Best Practices

| Practice | Status | Notes |
|----------|--------|-------|
| Flake-based configuration | ✅ | Modern approach |
| Pinned inputs via flake.lock | ✅ | Reproducible builds |
| Overlay composition | ✅ | Well-organized |
| Custom module options | ✅ | Used for complex features |
| Tests | ⚠️ | No NixOS tests defined yet |
| CI/CD | ✅ | GitHub Actions for validation |
| Formatting | ⚠️ | No automated formatting in CI |

### 6.2 Home-Manager Best Practices

| Practice | Status | Notes |
|----------|--------|-------|
| `useGlobalPkgs` | ✅ | Reduces evaluation time |
| `useUserPackages` | ✅ | Proper profile path |
| State version tracking | ✅ | Defined per-host |
| Shell integration | ✅ | `home.shell.enableFishIntegration` etc. |
| Session variables | ✅ | `systemd.user.sessionVariables` for graphical |

---

## 7. Feature Highlights

### 7.1 Distributed Builds

Custom module options for builder infrastructure:

```nix
options.distributed-build.client = {
  publicKey = lib.mkOption { ... };
  builders = lib.mkOption { ... };
};

options.distributed-build.server = {
  authorizedKeys = lib.mkOption { ... };
  signingKeyPath = lib.mkOption { ... };
};
```

### 7.2 Local Streaming Network

Declarative game streaming network with DHCP/DNS:

```nix
options.localStreaming = {
  enable = lib.mkOption { ... };
  wifiInterface = lib.mkOption { ... };
  streamingInterface = lib.mkOption { ... };
  # ... configurable IP addresses, DNS servers
};
```

### 7.3 Niri Window Manager

Modular configuration split into:
- `niri.nix` - Core NixOS and Home-Manager setup
- `input.nix` - Keyboard, mouse, touchpad settings
- `appearance.nix` - Layout, colors, window rules
- `keybinds.nix` - Comprehensive keybind configuration with DMS integration

### 7.4 Shell Support

Multiple shells configured:
- **Fish** - Primary shell with abbreviations, plugins, functions
- **Nushell** - Modern shell with structured data, custom commands
- **Zsh** - Available as alternative

---

## 8. Potential Expansion Directions

### 8.1 Short-term Improvements

1. **Add formatting to CI** (`alejandra` or `nixfmt`):
   ```yaml
   - name: Check formatting
     run: nix fmt -- --check
   ```

2. **Implement NixOS tests** for critical configurations

3. **Investigate Stylix** for unified theming across niri, shells, and applications

### 8.2 Medium-term Enhancements

1. **Disko integration** - Declarative disk partitioning
2. **Impermanence module** - Stateless root filesystem
3. **Custom module options** - `options.my.development.enable` pattern
4. **Roles abstraction** - `workstation`, `server`, `gaming` presets

### 8.3 Infrastructure

1. **NixOS tests** for boot, services, and user configuration
2. **Binary cache** - Set up Cachix or similar for faster builds
3. **Automatic updates** - Scheduled flake.lock updates with CI

---

## 9. Metrics Summary

| Metric | Value |
|--------|-------|
| Total Nix files | 105 |
| Host configurations | 4 |
| Feature modules | ~55 |
| Flake inputs | 17 |
| Overlays | 6 |
| Custom module options | 2 major (distributed-build, localStreaming) |
| CI jobs | 2 (check, build matrix) |

---

## 10. Conclusion

This is a **well-structured, production-quality configuration** that demonstrates excellent understanding of modern Nix patterns. Since the last analysis, significant improvements have been made in security (sops-nix), maintainability (module splits), and infrastructure (CI/CD).

**Key Strengths:**
- Modern flake-based architecture with dendritic pattern
- Good separation of concerns with multi-context modules
- Multi-platform support (Linux + Darwin)
- Secure secrets management with sops-nix
- CI/CD pipeline for validation
- Custom module options for complex features
- Comprehensive documentation (README, TODO, inline comments)

**Remaining Priorities:**
1. Add NixOS tests for critical configurations
2. Add formatting checks to CI
3. Consider Stylix integration for theming

**Technical Debt:**
- Minimal: hardcoded theme colors could use Stylix
- Some modules could benefit from additional comments

The codebase is in excellent shape for personal use and demonstrates a thoughtful, evolving approach to NixOS configuration management.

---

*This analysis was generated by reviewing all 105 Nix files in the repository, examining the flake.lock dependency graph, and evaluating against Nix community best practices.*
