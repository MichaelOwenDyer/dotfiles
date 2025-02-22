# Home-manager modules usable on NixOS only

{
  config,
  lib,
  home-manager,
  ...
}:

{
  imports = [
    # Use Home Manager as a NixOS module
    home-manager.nixosModules.home-manager
    # Import the default options and config
    ../default.nix
    # Import the rest of the modules
    ./browser
    ./chat
    ./wm
    ./caffeine.nix
    ./stylix.nix
  ];

  # Declare profile configuration options specific to NixOS systems
  options = {
    profiles =
      with lib.types;
      lib.mkOption {
        type = attrsOf (submodule {
          options = {
            hashedPassword = lib.mkOption {
              type = str;
              description = "Hashed password of the user";
            };
            extraGroups = lib.mkOption {
              type = listOf str;
              default = [];
              description = "Extra groups to add the user to";
            };
          };
        });
      };
  };

  # Use config.profiles to define Linux user profiles and configure home-manager
  config = {
    # Register a Linux system user account for each profile
    users.users = lib.mapAttrs (username: profile: {
      isNormalUser = true;
      description = profile.fullName;
      hashedPassword = profile.hashedPassword;
      extraGroups = profile.extraGroups;
    }) config.profiles;

    # On Linux, we put all user home directories in /home/
    home-manager.users = lib.mapAttrs (username: profile: {
      home.homeDirectory = /home/${username};
    }) config.profiles;
  };
}
