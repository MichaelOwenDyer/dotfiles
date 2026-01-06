{
  inputs,
  ...
}:
{
  # nh - Nix helper tool
  flake-file.inputs = {
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  flake.modules.nixos.overlays = {
    nixpkgs.overlays = [ inputs.nh.overlays.default ];
  };

  flake.modules.darwin.overlays = {
    nixpkgs.overlays = [ inputs.nh.overlays.default ];
  };

  flake.modules.homeManager.nh =
    { config, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "${config.home.homeDirectory}/.dotfiles";
        clean = {
          enable = true;
          dates = "weekly";
          extraArgs = "--keep-since 7d --keep 7";
        };
      };

      home.sessionVariables = {
        NH_FLAKE = "${config.home.homeDirectory}/.dotfiles";
      };
    };
}
