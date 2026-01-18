{
  ...
}:
{
  # GNOME Keyring for secrets management

  flake.modules.nixos.gnome-keyring = {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
  };
}
