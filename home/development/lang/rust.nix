{ config, lib, pkgs, ... }:

{
  config.home-manager.users = lib.mapAttrs (username: profile: let rustConfig = profile.development.lang.rust; in {
    # Install Rustup for the user if enabled
    home.packages = lib.optionals rustConfig.enable [
      pkgs.rustup
    ];
  }) config.profiles;
}