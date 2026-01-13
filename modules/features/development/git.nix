{
  ...
}:
let
  settings = {
    init.defaultBranch = "main";
    pull.rebase = true;
    url = {
      "https://github.com" = {
        insteadOf = [
          "gh:"
          "github:"
        ];
      };
    };
  };
in
{
  flake.modules.nixos.git = {
    programs.git = {
      enable = true;
      config = settings;
    };
  };

  flake.modules.darwin.git =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];
    };

  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      inherit settings;
    };
  };
}
