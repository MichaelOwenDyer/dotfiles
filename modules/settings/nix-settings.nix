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
}
