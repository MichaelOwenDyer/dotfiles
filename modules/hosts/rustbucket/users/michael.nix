{
  inputs,
  ...
}:
{
  flake.modules.nixos.michael-rustbucket =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael-rustbucket ];
      };
    };

  flake.modules.homeManager.michael-rustbucket =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        niri
        niri-outputs-rustbucket
        dank-material-shell
        idle
        development
        gaming
        discord
        rust
        syncthing
      ];

      home.packages = with pkgs; [
        zotero
        obsidian
      ];

      programs.yazi.impermanence.enable = true;

      services.idle = {
        displayTimeout = 600;
        lockTimeout = 1200;
      };

      home.stateVersion = "24.11";
    };

  flake.lib.keys.ssh.user."michael@rustbucket" = {
    pub = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvS0a2EKa9kxQ1DK3JMS6UVYOXnOvlTFQzukp9U/M4n michael@rustbucket";
    privateKeySecret = "ssh-michael-rustbucket";
    deployPath = "/home/michael/.ssh/id_ed25519";
    owner = "michael";
  };
}
