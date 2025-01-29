{ config, lib, pkgs, ... }: 

{
  imports = [
    ./default.nix
  ];

	development.ide.jetbrains = {
		plugins = [ "com.github.copilot" ];
		intellij-idea.enable = true;
		intellij-idea.plugins = [ "nix-idea" ];
		rust-rover.enable = true;
	};
}