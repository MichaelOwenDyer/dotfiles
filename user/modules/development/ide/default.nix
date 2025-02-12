{ config, lib, pkgs, ... }:

{
	imports = [
		./vscode.nix
		./cursor.nix
		./jetbrains
	];
}