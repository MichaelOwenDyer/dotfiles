_:

{
  imports = [
    ../default.nix
  ];

  config.profiles.michael = {
    home-manager.stateVersion = "25.05";
    development.ide.vscode.enable = true;
    caffeine.enable = false;
  };
}
