{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./default.nix
  ];

  profiles.michael = {
    development.ide.cursor = {
      enable = true;
    };
  };
}
