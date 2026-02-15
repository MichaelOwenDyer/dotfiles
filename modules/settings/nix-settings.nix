{
  ...
}:
{
  # Nix and Flakes configuration

  flake.modules.nixos.nix-settings =
    { ... }:
    {
      nixpkgs.config.allowUnfree = true;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        trusted-users = [
          "root"
          "@wheel"
        ];
      };

      nix.extraOptions = ''
        warn-dirty = false
      '';

      # Garbage collection is handled by nh clean (see modules/features/nh/nh.nix)

      impermanence.ephemeralPaths = [
        "/etc/nix"
        "/etc/nixos"
        "/etc/profiles"
        "/etc/static"
      ];
    };

  # Settings for ad-hoc nix commands (nix run, nix shell, etc.)
  flake.modules.homeManager.nix-settings =
    { config, ... }:
    {
      # nixpkgs.config only affects home-manager packages when useGlobalPkgs = false.
      # For ad-hoc commands (nix run, nix shell, etc.), we need ~/.config/nixpkgs/config.nix
      home.file."${config.xdg.configHome}/nixpkgs/config.nix".text = ''
        {
          allowUnfree = true;
        }
      '';

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        warn-dirty = false;
      };
    };
}
