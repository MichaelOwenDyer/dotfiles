{
  config,
  lib,
  pkgs,
  ...
}:

{
  # Declare configuration options for Nix under options.profiles.<name>.development.lang.nix
  options.profiles =
    with lib.types;
    lib.mkOption {
      type = attrsOf (submodule {
        options.development.lang.nix = {
          enable = lib.mkEnableOption "Nix programming language support";
        };
      });
    };

  config = {
    # Configure Nix for each user profile
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.development.lang.nix;
      in
      lib.mkIf cfg.enable {
        home.packages = with pkgs; [
          nixd # Nix LSP
          nixfmt-rfc-style # Nix formatting
        ];
      }
    ) config.profiles;
  };
}
