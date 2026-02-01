{
  inputs,
  ...
}:
{
  flake.modules.nixos.michael-rpi-3b =
    { pkgs, ... }:
    let
      sshKeys = inputs.self.lib.sshKeys;
    in
    {
      imports = with inputs.self.modules.nixos; [ home-manager fish-shell ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael-rpi-3b ];
      };

      users.users.michael = {
        isNormalUser = true;
        description = "michael";
        shell = pkgs.fish;
        extraGroups = [
          "wheel"
          "video"
          "audio"
          "input"
          "networkmanager"
          "podman"
          "docker"
        ];
        openssh.authorizedKeys.keys = with sshKeys; [
          "michael@claptrap".pub
          "michael@rustbucket".pub
          "michael@mac".pub
        ];
      };
    };

  # Host-specific home-manager configuration for michael on rpi-3b
  flake.modules.homeManager.michael-rpi-3b =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
        gitui
        ide-helix
        yazi
        nh
      ];

      home.stateVersion = "25.11";
    };
}
