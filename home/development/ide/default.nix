{ config, lib, pkgs, ... }:

{
	imports = [
		./vscode.nix
		./jetbrains
	];
}