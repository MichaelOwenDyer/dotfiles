{
  config,
  lib,
  util,
  pkgs,
  nix-jetbrains-plugins,
  ...
}:

{
  # Declare configuration options for RustRover under options.profiles.<name>.development.ide.jetbrains.rust-rover
  options = with lib.types; util.mkProfileOption lib {
    development.ide.jetbrains.rust-rover = {
      enable = lib.mkEnableOption "RustRover IDE";
      # See all available plugins at
      # https://raw.githubusercontent.com/theCapypara/nix-jetbrains-plugins/refs/heads/main/generated/all_plugins.json
      plugins = lib.mkOption {
        type = listOf str;
        default = [];
        description = "Plugins to install with RustRover";
      };
    };
  };

  # Configure RustRover for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        # Get the RustRover configuration for the profile
        cfg = profile.development.ide.jetbrains.rust-rover;
        # Combine the user's default Jetbrains plugins with the user's RustRover plugins
        plugins = profile.development.ide.jetbrains.plugins ++ cfg.plugins;
        # Construct the RustRover package with all plugins
        rust-rover = nix-jetbrains-plugins.buildIdeWithPlugins pkgs.jetbrains "rust-rover" plugins;
      in
      lib.mkIf cfg.enable {
        # Add RustRover to the user's home packages
        home.packages = [ rust-rover ];
      }
    ) config.profiles;
  };
}
