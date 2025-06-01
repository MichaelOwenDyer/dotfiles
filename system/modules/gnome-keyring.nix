{
  pkgs,
  lib,
  config,
  ...
}:

{
  # Declare the option to enable or disable gnome-keyring
  options.gnome-keyring.enable = lib.mkEnableOption "gnome-keyring";

  config = lib.mkIf config.gnome-keyring.enable {
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true; # frontend for managing keys and passwords
    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      greetd-password.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
    };
    services.dbus.packages = [ pkgs.gnome-keyring pkgs.gcr ];
    services.xserver.displayManager.sessionCommands = ''
      eval $(gnome-keyring-daemon --start --daemonize --components=ssh,secrets)
      export SSH_AUTH_SOCK
    '';
    environment.systemPackages = [ pkgs.libsecret ];
  };
}