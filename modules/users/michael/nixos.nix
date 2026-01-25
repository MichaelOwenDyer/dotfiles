{
  inputs,
  ...
}:
let
  name = "Michael Dyer";
  email = "michaelowendyer@gmail.com";
  trustedSshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHvS0a2EKa9kxQ1DK3JMS6UVYOXnOvlTFQzukp9U/M4n michael@rustbucket"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAaQ4EQjxoG3L5kMu5wK1eE1w6V4y1lw3/ynJfd/0Nis michael.dyer@JGFQQXM192"
  ];
in
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
        description = name;
        # Password hash is read from the decrypted secret at /run/secrets/michael-password
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
        openssh.authorizedKeys.keys = trustedSshKeys;
      };
    };
}
