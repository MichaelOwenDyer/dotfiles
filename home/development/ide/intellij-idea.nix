{ config, settings, lib, pkgs, ... }: let
	jetbrainsPlugins = import ./jetbrains-plugins.nix;
  plugins = [ ];
in {
  # Mark IntelliJ IDEA as enabled for other modules to see
  config.development.ide.intellij-idea.enable = true;
  # If we are enabling IntelliJ IDEA, we probably also want Java enabled
  config.development.lang.java.enable = lib.mkDefault true;

  config.home-manager.users.${config.username} = let 
    allPlugins = jetbrainsPlugins ++ plugins ++ config.development.ide.intellij-idea.extraPlugins;
    ideaPkg = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate allPlugins;
  in {
    home.packages = [ ideaPkg ];
  };
}