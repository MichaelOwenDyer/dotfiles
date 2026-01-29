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

        # Disable the global flake registry for faster commands and explicit dependencies
        flake-registry = "";
        use-registries = false;
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
