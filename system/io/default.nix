{ config, lib, pkgs, ... }:

{
	imports = [
		./audio.nix
		./printing.nix
		./wifi.nix
	];
}