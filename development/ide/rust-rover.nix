{ config, lib, pkgs, ... }: let 
  jetbrainsPlugins = import ./jetbrains-plugins.nix;
  rustRoverPlugins = [];
in {
  # Mark RustRover as enabled for other modules to see
  config.development.ide.rust-rover.enable = true;
  # If we are enabling RustRover, we probably also want Rust enabled
  config.development.lang.rust.enable = lib.mkDefault true;

  config.home-manager.users.${config.username} = let
    allPlugins = jetbrainsPlugins ++ rustRoverPlugins ++ config.development.ide.rust-rover.extraPlugins;
    rustRoverPkg = jetbrains.plugins.addPlugins jetbrains.rust-rover allPlugins;
  in {
    home.packages = [ rustRoverPkg ];
  };
}