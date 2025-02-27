{
  lib,
  pkgs,
  ...
}:

{
  config.profiles.michael = {
    development.lang = {
			nix.enable = true;
			rust.enable = true;
			java = {
				enable = lib.mkDefault true;
				mainPackage = pkgs.zulu17;
			};
		};
  };
}