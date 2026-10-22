{
  inputs,
  lib,
  ...
}:
{
  # Extra NixOS configuration for any system michael is a user on
  flake.modules.nixos.michael =
    { pkgs, config, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        home-manager # Enable home-manager on this NixOS system
        fish-shell
      ];

      # Decrypt the password hash at activation time before user creation
      sops.secrets."michael-password".neededForUsers = true;

      users.users.michael = {
        isNormalUser = true;
        description = "Michael Dyer";
        hashedPasswordFile = config.sops.secrets."michael-password".path;
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
        openssh.authorizedKeys.keys = with inputs.self.lib.hosts; [
          rustbucket.keys.users.michael.pub
          claptrap.keys.users.michael.pub
          rpi-3b.keys.users.michael.pub
          mac.keys.users.michael.pub
          phone.keys.users.michael.pub
        ];
      };
    };
}
