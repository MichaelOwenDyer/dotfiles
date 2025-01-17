{ config, lib, pkgs, ... }:

{
    imports = [
        # TODO: Figure out how to import home-manager here
        ./browser
        ./chat
        ./development
        ./shell
    ];

	options = import ./options.nix { inherit lib; };

	config = import ./settings.nix { inherit config lib pkgs; };
}