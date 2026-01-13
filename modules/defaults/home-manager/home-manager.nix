{
  inputs,
  ...
}:
let
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
in
{
  # Home Manager configurations for NixOS and Darwin systems
  flake.modules.nixos.home-manager = { inherit home-manager; };

  flake.modules.darwin.home-manager = { inherit home-manager; };
}
