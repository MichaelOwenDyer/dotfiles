# My NixOS Configuration

A multi-host, multi-platform Nix configuration managing NixOS, macOS (nix-darwin), and home-manager across several machines.

## Architecture

This configuration uses a **dendritic pattern** powered by:
- [flake-parts](https://github.com/hercules-ci/flake-parts) - Module-based flake structure
- [flake-file](https://github.com/vic/flake-file) - Auto-generates `flake.nix` from module options
- [import-tree](https://github.com/vic/import-tree) - Recursively imports all `.nix` files in `modules/`

The `flake.nix` is auto-generated. Run `nix run .#write-flake` to regenerate it after modifying `flake-file.inputs` in any module.

## Directory Structure

```
modules/
├── defaults/           # Base configurations applied to all systems
│   ├── nixos-default.nix
│   ├── darwin-default.nix
│   └── home-manager/
├── features/           # Composable feature modules
│   ├── browser/        # zen, firefox, chrome
│   ├── development/    # git, direnv, shell aliases, etc.
│   ├── ide/            # helix, cursor, vscode
│   ├── shell/          # fish, zsh
│   ├── window-manager/ # niri, gnome, hyprland, ly
│   └── ...
├── hosts/              # Per-machine configurations
│   ├── claptrap/       # Dell XPS 13 laptop
│   ├── rustbucket/     # Gaming desktop (Nvidia)
│   ├── rpi-3b/         # Raspberry Pi 3B
│   └── mac/            # macOS workstation
├── repositories/       # nixpkgs overlays (stable, master, NUR)
├── settings/           # System settings (audio, bluetooth, wifi, etc.)
├── users/              # User configurations
└── lib.nix             # Helper functions (mkNixos, mkDarwin, mkHomeManager)
```

## Hosts

| Host | Architecture | Description |
|------|--------------|-------------|
| `claptrap` | x86_64-linux | Dell XPS 13 9360 laptop with Niri WM |
| `rustbucket` | x86_64-linux | Gaming PC with Nvidia GPU, Steam |
| `rpi-3b` | aarch64-linux | Raspberry Pi 3B headless server |
| `mac` | aarch64-darwin | macOS workstation |

## Module Pattern

Features are defined as **multi-context modules** that provide configurations for NixOS, Darwin, and Home-Manager in a single file:

```nix
# Example: modules/features/development/git.nix
{
  flake.modules.nixos.git = { ... };
  flake.modules.darwin.git = { ... };
  flake.modules.homeManager.git = { ... };
}
```

Modules are composed by importing them in host or user configurations:

```nix
# modules/hosts/claptrap/configuration.nix
imports = with inputs.self.modules.nixos; [
  laptop
  niri
  ssh
  michael-claptrap
];
```

## Usage

### Rebuild NixOS

```bash
# Using nh (recommended)
# Step 1: build the configuration from the current code (don't forget to run git add . beforehand for any added files)
nh os build

# Load into the built configuration for testing
nh os test

# If it looks good, add it to the list of boot configurations
nh os boot
```

### Rebuild macOS (nix-darwin)

```bash
nh darwin switch --flake .#mac
```

### Rebuild Home-Manager (standalone)

```bash
nh home switch --flake .#<user>@<host>
```

### Update Flake Inputs

```bash
nix flake update
```

## Key Technologies

- **Window Manager**: [Niri](https://github.com/YaLTeR/niri) (scrolling tiling Wayland compositor)
- **Shell**: [Dank Material Shell](https://github.com/noctalia-dev/noctalia-shell) status bar
- **Display Manager**: [ly](https://github.com/fairyglade/ly)
- **Terminal**: [Ghostty](https://ghostty.org/)
- **Editor**: [Helix](https://helix-editor.com/) (terminal), [Cursor](https://cursor.sh/) (GUI)
- **Browser**: [Zen Browser](https://zen-browser.app/)
- **Shell**: [Fish](https://fishshell.com/)
- **Version Control**: Git + [Jujutsu](https://github.com/martinvonz/jj)

## Contributing

See [TODO.md](TODO.md) for planned improvements and known issues.

## License

See [LICENSE](LICENSE).
