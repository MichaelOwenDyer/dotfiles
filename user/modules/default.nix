{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}:

{
  imports = [
    # Everything in the user directory uses home-manager, so its module is made available here
    home-manager.nixosModules.home-manager
    ./browser
    ./chat
    ./development
    ./shell
    ./wm
    ./caffeine.nix
  ];

  # Declare basic profile configuration options
  options.profiles =
    with lib.types;
    lib.mkOption {
      type = attrsOf (submodule {
        options = {
          fullName = lib.mkOption {
            type = str;
            description = "Full name of the user";
          };
          email = lib.mkOption {
            type = str;
            description = "Email address of the user";
          };
          hashedPassword = lib.mkOption {
            type = str;
            description = "Hashed password of the user";
          };
          extraGroups = lib.mkOption {
            type = listOf str;
            default = [ ];
            description = "Extra groups to add the user to";
          };
          extraPackages = lib.mkOption {
            type = listOf package;
            default = [ ];
            description = "Packages to install for the user";
          };
        };
      });
    };

  config = {
    # Register a system user account for each profile
    users.users = lib.mapAttrs (username: profile: {
      isNormalUser = true;
      description = profile.fullName;
      hashedPassword = profile.hashedPassword;
      extraGroups = profile.extraGroups;
    }) config.profiles;

    # By default, home manager wants to use a separate nixpkgs instance for each user, but this tells it to use the system nixpkgs
    home-manager.useGlobalPkgs = true;
    # By default, home manager will install packages in /home/<username>/.nix-profile, but this puts them in /etc/profiles
    home-manager.useUserPackages = true;
    # Configure home manager for each profile
    home-manager.users = lib.mapAttrs (username: profile: {
      # Let home manager install and manage itself
      programs.home-manager.enable = true;
      # Always allow unfree packages
      nixpkgs.config.allowUnfree = true;
      # Set username to the profile name (the key in config.profiles)
      home.username = username;
      # Set home directory
      home.homeDirectory = "/home/${username}";
      # Add extra packages in profile to home.packages
      home.packages = profile.extraPackages;
      # Set state version for home-manager as the system state version
      home.stateVersion = config.system.stateVersion;
    }) config.profiles;
  };
}
