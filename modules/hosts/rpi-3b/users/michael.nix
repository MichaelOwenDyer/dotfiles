{
  inputs,
  ...
}:
{
  flake.modules.nixos.michael-rpi-3b =
    { pkgs, ... }:
    let
      trustedSshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvS0a2EKa9kxQ1DK3JMS6UVYOXnOvlTFQzukp9U/M4n michael@rustbucket"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaQ4EQjxoG3L5kMu5wK1eE1w6V4y1lw3/ynJfd/0Nis michael.dyer@JGFQQXM192"
      ];
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
        openssh.authorizedKeys.keys = trustedSshKeys;
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
        # nh
      ];

      home.stateVersion = "25.11";
    };
}
