{ config, settings, lib, pkgs, ... }:

{
	options.development.lang.rust = {
		enable = lib.mkEnableOption "Rust programming language support";
	};

  config.home-manager.users.${config.username}.home.packages = with pkgs; [ rustup ];
}