{ config, settings, lib, pkgs, ... }:

{
  config.home-manager.users = lib.mapAttrs (username: profile:
    let 
      # Get the JetBrains configuration for the user
      jetbrainsConfig = profile.development.ide.jetbrains;
      # Combine the user's default Jetbrains plugins with the user's IntelliJ IDEA plugins
      allPlugins = jetbrainsConfig.default-plugins ++ jetbrainsConfig.intellij-idea.plugins;
      # Construct the IntelliJ IDEA package with all plugins
      ideaPkg = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate allPlugins;
    in {
      # Add IntelliJ IDEA to the user's home packages
      home.packages = [ ideaPkg ];
    }
  ) config.profiles;
}