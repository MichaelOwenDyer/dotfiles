{
  ...
}:
{
  flake.modules.nixos.ghostty = {
    programs.ghostty = {
      enable = true;
    };
  };

  flake.modules.darwin.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
      };
    };

  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
      };
    };
}
