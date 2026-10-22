{
  inputs,
  ...
}:
{
  flake.modules.nixos.michael-rpi-3b =
    { pkgs, ... }:
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
        openssh.authorizedKeys.keys = with inputs.self.lib; [
          hosts.claptrap.keys.users.michael.pub
          hosts.rustbucket.keys.users.michael.pub
          hosts.mac.keys.users.michael.pub
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

  flake.lib.hosts.rpi-3b.keys.users.michael = {
    pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b";
    privateKeySecret = "ssh-michael-rpi-3b";
    deployPath = "/home/michael/.ssh/id_ed25519";
    owner = "michael";
  };
}
