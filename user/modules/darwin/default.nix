# Home-manager modules usable on Darwin only
# Darwin systems should import this to access all relevant system modules

{
  config,
  lib,
  home-manager,
  ...
}:

{
  imports = [
    # Use Home Manager as a Darwin module
    home-manager.darwinModules.home-manager
    # Import the default options and config
    ../default.nix
    # TODO: Add Darwin user modules
  ];

  # Use config.profiles to define MacOS user profiles and configure home-manager
  config = {
    # Register a MacOS system user account for each profile
    users.users = lib.mapAttrs (username: profile: {
      packages = [];
      description = profile.fullName;
      createHome = false;
      # On MacOS, home directories are in /Users/
      home = /Users/${username};
    }) config.profiles;

    # Tell home-manager to use the same home directory as above
    home-manager.users = lib.mapAttrs (username: profile: {
      home.homeDirectory = config.users.users.${username}.home;
    }) config.profiles;
  };
}
