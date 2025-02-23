{
  config,
  lib,
  util,
  pkgs,
  ...
}:

{
  # Declare configuration options for Rust under profiles.<name>.development.lang.rust
  options = util.mkProfileOption lib {
    development.lang.rust = {
      enable = lib.mkEnableOption "Rust programming language support";
    };
  };

  # Configure Rust for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.development.lang.rust;
      in
      lib.mkIf cfg.enable {
        # Install Rustup for the user if enabled
        home.packages = with pkgs; [ rustup ];
      }
    ) config.profiles;
  };
}
