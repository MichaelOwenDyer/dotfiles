{
  config,
  lib,
  ...
}:

{
  imports = [
    ./zsh.nix
  ];

  # Declare configuration options for all shells
  options = {
    profiles =
      with lib.types;
      lib.mkOption {
        type = attrsOf (submodule {
          options.development = {
            shellAliases = lib.mkOption {
              type = attrsOf str;
              default = {};
              description = "Aliases to add for all shells";
            };
          };
        });
      };
  };

  # Configure shell aliases for all shells for each user profile
  config = {
    home-manager.users = lib.mapAttrs (username: profile: {
      home.shellAliases = profile.development.shellAliases;
    }) config.profiles;
  };
}
