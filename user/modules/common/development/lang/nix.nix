{
  config,
  lib,
  util,
  pkgs,
  ...
}:

{
  # Declare configuration options for Nix under options.profiles.<name>.development.lang.nix
  options = util.mkProfileOption lib {
    development.lang.nix = {
      enable = lib.mkEnableOption "Nix programming language support";
    };
  };

	# Configure Nix for each user profile
  config = {
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
