{ config, lib, pkgs, ... }:

{
	imports = [
		./intellij-idea.nix
		./rust-rover.nix
	];
}