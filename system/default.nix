{ config, lib, pkgs, ... }:

{
	imports = [
		./io/audio.nix
	];

	options = import ./options.nix { inherit lib; };

	config = import ./settings.nix { inherit config lib pkgs; };
}
