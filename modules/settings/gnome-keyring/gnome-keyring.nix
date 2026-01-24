{
  ...
}:
{
  # GNOME Keyring for secrets management
  #
  # Provides the org.freedesktop.secrets D-Bus API for applications
  # like VSCode, browsers, and Git credential helpers.
  #
  # The keyring is automatically unlocked at login when the PAM module
  # is enabled for the display manager's PAM service.

  flake.modules.nixos.gnome-keyring = {
    services.gnome.gnome-keyring.enable = true;

    # Enable PAM integration for keyring auto-unlock
    # The login keyring password must match the user's login password
    security.pam.services = {
      # Console login (tty)
      login.enableGnomeKeyring = true;
      # ly display manager - required for graphical login unlock
      ly.enableGnomeKeyring = true;
      # Also update keyring password when user password changes
      passwd.enableGnomeKeyring = true;
    };
  };
}
