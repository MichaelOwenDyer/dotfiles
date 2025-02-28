# Home-manager modules usable on NixOS only

{
  config,
  lib,
  util,
  ...
}:

{
  imports = [
    ../.
    ./browser
    ./chat
    ./wm
    ./caffeine.nix
    ./stylix.nix
  ];

  # Declare profile configuration options specific to NixOS systems
  options = with lib.types; util.mkProfileOption lib {
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
      home.homeDirectory = "/home/${username}";
    }) config.profiles;
  };
}
