{ ... }:

{
  imports = [
    ./default.nix
  ];

  config.profiles.michael = {
    development.ide.cursor = {
      enable = true;
    };
  };
}
