{ config, pkgs, ... }:

{
  config.development.lang.rust.enable = true;
  config.home-manager.users.${config.username}.home.packages = with pkgs; [ rustup ];
}