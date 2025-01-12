{ config, settings, lib, pkgs, ... }: let
	commonPlugins = import ./common-plugins.nix;
  plugins = [ ];
in {

  # Define the options for the IntelliJ IDEA module
  options.development.ide.intellij-idea = {
    extraPlugins = lib.mkOption {
      type = lib.types.listOf lib.types.string;
      default = [];
      description = "Extra plugins to install with IntelliJ IDEA";
    };
  };

  # If we are enabling IntelliJ IDEA, we probably also want Java enabled
  config.development.lang.java.enable = lib.mkDefault true;

  config.home-manager.users.${config.username} = let 
    allPlugins = commonPlugins ++ plugins ++ config.development.ide.intellij-idea.extraPlugins;
    ideaPkg = jetbrains.plugins.addPlugins jetbrains.idea-ultimate allPlugins;
  in {
    home.packages = [ ideaPkg ];
  };
}