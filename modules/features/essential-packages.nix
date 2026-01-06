{
  ...
}:
{
  flake.modules =
    let
      selectPackagesFrom = pkgs: with pkgs; [
        git
        gitui
        ripgrep
        yazi
        helix
        fd
        tree
        openssh
        gnupg1
        curl
        wget
      ];
    in
    {
      nixos.essential-packages =
        { pkgs, ... }:
        {
          environment.systemPackages = selectPackagesFrom pkgs;
        };
      darwin.essential-packages =
        { pkgs, ... }:
        {
          environment.systemPackages = selectPackagesFrom pkgs;
        };
      homeManager.essential-packages =
        { pkgs, ... }:
        {
          home.packages = selectPackagesFrom pkgs;
        };
    };
}