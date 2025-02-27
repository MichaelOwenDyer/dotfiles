_:

{
  imports = [
    ../common
  ];

  config.profiles.michael = {
    home-manager.stateVersion = "25.05";
    development = {
      lang.nix.enable = true;
      ide.vscode = {
        enable = true;
      };
    };
    caffeine.enable = false;
  };
}
