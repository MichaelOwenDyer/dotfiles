{ ... }:

{
  config.profiles.michael = {
    fullName = "Michael Dyer";
    email = "michaelowendyer@gmail.com";
    home-manager.stateVersion = "25.05";
    development = {
      lang.nix.enable = true;
      ide.vscode = {
        enable = true;
      };
    };
  };
}
