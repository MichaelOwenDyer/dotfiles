{
  config,
  lib,
  pkgs,
  ...
}:

{
  xsession = {
    enable = true;
    windowManager.command = "gnome-session";
  };

  # Add some extra GNOME packages
  home.packages = with pkgs; [
    gnome-session
    gnome-screenshot
    gnome-tweaks
  ];

  # GNOME keyring is used for managing secrets and SSH keys
  services.gnome-keyring = {
    # Enable GNOME keyring
    enable = true;
    # Possible values: "pkcs11", "secrets", "ssh"
    components = [];
  };
}
