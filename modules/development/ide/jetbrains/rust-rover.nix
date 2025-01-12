{ config, lib, pkgs, ... }: let 
  jetbrainsPlugins = import ./common-plugins.nix;
  rustRoverPlugins = [];
in {

  # Define the options for the RustRover module
  options.development.ide.rust-rover = {
    extraPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [];
      description = "Extra plugins to install with RustRover";
    };
  };

  # If we are enabling RustRover, we probably also want Rust enabled
  config.development.lang.rust.enable = lib.mkDefault true;

  config.home-manager.users.${config.username} = let
    allPlugins = jetbrainsPlugins ++ rustRoverPlugins ++ config.development.ide.rust-rover.extraPlugins;
    rustRoverPkg = jetbrains.plugins.addPlugins jetbrains.rust-rover allPlugins;
  in {
    home.packages = [ rustRoverPkg ];
  };
}