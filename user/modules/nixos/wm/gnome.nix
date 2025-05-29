{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf (lib.any (profile: profile.windowManager == "gnome") (lib.attrValues config.profiles)) {
    # TODO: any way to achieve the full gnome desktop environment without system config?
    services.xserver.desktopManager.gnome.enable = true;

    home-manager.users = lib.mapAttrs (
      username: profile:
      lib.mkIf (profile.windowManager == "gnome") {
        # This enables the GNOME desktop environment
        # xsession = {
        #   enable = true;
        #   windowManager.command = "gnome-session";
        # };

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
          components = ["pkcs11" "secrets" "ssh"];
        };
      }
    ) config.profiles;
  };
}
