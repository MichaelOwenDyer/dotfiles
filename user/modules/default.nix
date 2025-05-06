# Common user module for both NixOS and Darwin
# Should be imported indirectly via ./nixos or ./darwin

{
  config,
  lib,
  util,
  ...
}:

{
  # Common modules should always be available
  imports = [
    ./common
  ];

  # Declare basic profile configuration options
  options = with lib.types; util.mkProfileOption lib {
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
      description = "Hashed password of the user (NixOS systems only)";
    };
    extraGroups = lib.mkOption {
      type = listOf str;
      default = [];
      description = "Extra groups to add the user to (NixOS systems only)";
    };
    extraPackages = lib.mkOption {
      type = listOf package;
      default = [];
      description = "Packages to install for the user";
    };
    programs = lib.mkOption {
      type = attrsOf anything;
      default = {};
      description = "Enable or disable specific programs for the user";
    };
    home-manager.stateVersion = lib.mkOption {
      type = str;
      # Use system state version by default
      # On Darwin, system state version is not a string like "24.11" but rather a number, so this must be overridden
      default = config.system.stateVersion;
      description = "Value of home-manager.users.<username>.home.stateVersion";
    };
  };

  config = {
    # Default to an empty set of profiles (in case of a system with no users for some reason)
    profiles = {};
    # By default, home manager wants to use a separate nixpkgs instance for each user, but this tells it to use the system nixpkgs
    home-manager.useGlobalPkgs = true;
    # By default, home manager will install packages in /home/<username>/.nix-profile, but this puts them in /etc/profiles
    home-manager.useUserPackages = true;

    # Configure home manager for each profile
    home-manager.users = lib.mapAttrs (username: profile: {
      programs = profile.programs // {
        home-manager.enable = true; # Let home manager install and manage itself
      };
      home = {
        inherit username; # Set username to the profile name (the key in config.profiles)
        packages = profile.extraPackages; # Add extra packages in profile to home.packages
        stateVersion = profile.home-manager.stateVersion; # Set state version for home-manager as the system state version
      };
    }) config.profiles;
  };
}
