{
  inputs,
  lib,
  ...
}:
{
  # Helper functions for creating system / home-manager configurations

  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    # Create a nixos configuration for a given system and module name
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          inputs.self.modules.nixos.overlays
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };

    # Create a darwin configuration for a given system and module name
    mkDarwin = system: name: {
      ${name} = inputs.nix-darwin.lib.darwinSystem {
        modules = [
          inputs.self.modules.darwin.${name}
          inputs.self.modules.darwin.overlays
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };

    # Create a home-manager configuration for a given system and module name
    mkHomeManager =
      system: name:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [ inputs.self.modules.homeManager.${name} ];
      };
  };
}
