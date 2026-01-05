{
  inputs,
  ...
}:
{
  # Assign user michael to host mac

  flake.modules.darwin.mac =
    { pkgs, ... }:
    {
      home-manager.users."michael.dyer" = {
        imports = [ inputs.self.modules.homeManager."michael@mac" ];
      };

      users.users."michael.dyer" = {
        name = "michael.dyer";
        home = "/Users/michael.dyer";
        shell = pkgs.zsh;
      };

      system.primaryUser = "michael.dyer";
    };

  # Host-specific home-manager configuration for michael on mac
  flake.modules.homeManager."michael@mac" =
    { lib, pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        system-default
        nh
        git
        gitui
        yazi
        ide-helix
        ide-vscode
      ];

      programs.git.settings.user = {
        name = "Michael Dyer";
        email = "michael.dyer@check24.de";
      };

      home.packages = with pkgs; [
        ripgrep
        alt-tab-macos
        jq
        mos
        scroll-reverser
        hours
        orbstack
        nodejs_24
        pnpm_9
        maven
        gradle_9
      ];

      home.homeDirectory = lib.mkForce "/Users/michael.dyer";
      home.stateVersion = "26.05";
    };
}
