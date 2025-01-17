{ config, lib, pkgs, ... }:

{
  config.home-manager.users = lib.mapAttrs (username: profile:
    let
      # Get the Jetbrains configuration for the user
      jetbrainsConfig = profile.development.ide.jetbrains;
      # Combine the user's default Jetbrains plugins with the user's RustRover plugins
      allPlugins = jetbrainsConfig.default-plugins ++ jetbrainsConfig.rust-rover.plugins;
      # Construct the RustRover package with all plugins
      rustRoverPkg = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.rust-rover allPlugins;
    in {
      # Add RustRover to the user's home packages
      home.packages = [ rustRoverPkg ];
    }
  ) config.profiles;
}