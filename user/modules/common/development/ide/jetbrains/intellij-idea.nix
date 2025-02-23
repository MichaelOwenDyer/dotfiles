{
  config,
  lib,
  pkgs,
  nix-jetbrains-plugins,
  ...
}:

{
  # Declare configuration options for JetBrains IntelliJ IDEA under options.profiles.<name>.development.ide.jetbrains.intellij-idea
  options = {
    profiles =
      with lib.types;
      lib.mkOption {
        type = attrsOf (submodule {
          options.development.ide.jetbrains.intellij-idea = {
            enable = lib.mkEnableOption "IntelliJ IDEA";
            # See all available plugins at
            # https://raw.githubusercontent.com/theCapypara/nix-jetbrains-plugins/refs/heads/main/generated/all_plugins.json
            plugins = lib.mkOption {
              type = listOf str;
              default = [];
              description = "Plugins to install in IntelliJ IDEA";
            };
          };
        });
      };
  };

  # Configure JetBrains IntelliJ IDEA for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        # Get the IntelliJ IDEA configuration for the profile
        cfg = profile.development.ide.jetbrains.intellij-idea;
        # Combine the user's default Jetbrains plugins with the user's IntelliJ IDEA plugins
        plugins = profile.development.ide.jetbrains.plugins ++ cfg.plugins;
        # Construct the IntelliJ IDEA package with all plugins
        idea-ultimate = nix-jetbrains-plugins.buildIdeWithPlugins pkgs.jetbrains "idea-ultimate" plugins;
      in
      lib.mkIf cfg.enable {
        # Add IntelliJ IDEA to the user's home packages
        home.packages = [ idea-ultimate ];
      }
    ) config.profiles;
  };
}
