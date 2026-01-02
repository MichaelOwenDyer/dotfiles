{
  inputs,
  ...
}:
let
  home-manager-config = {
    home-manager = {
      verbose = true;
      # Changes the home-manager package installation path
      # from $HOME/.nix-profile to /etc/profiles.
      useUserPackages = true;
      # Inherit nixpkgs instance from NixOS.
      # This saves us an expensive second evaluation of nixpkgs
      # when rebuilding NixOS and home-manager together,
      # at the expense of higher coupling.
      useGlobalPkgs = true;
      backupFileExtension = "backup";
    };
  };
in
{
  flake.modules.nixos.home-manager = {
    imports = [
      inputs.home-manager.nixosModules.home-manager
      home-manager-config
    ];
  };

  flake.modules.darwin.home-manager = {
    imports = [
      inputs.home-manager.darwinModules.home-manager
      home-manager-config
    ];
  };
}
