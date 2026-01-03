{
  inputs,
  ...
}:
let
  username = "michael";
  name = "Michael Dyer";
  email = "michaelowendyer@gmail.com";
  defaultHashedPassword = "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";
  trustedSshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINj8NsgxdKFSwaLN5cK2vebcfdWTI39OoAutnMI9awyD michael@rustbucket"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b"
  ];
in
{
  # NixOS user configuration
  flake.modules.nixos.${username} =
    { pkgs, lib, config, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        shell-fish
      ];

      users.users.${username} = {
        isNormalUser = true;
        description = name;
        hashedPassword = lib.mkDefault defaultHashedPassword;
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

  # Darwin user configuration
  flake.modules.darwin.${username} =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        shell-zsh
      ];

      home-manager.users.${username} = {
        imports = [ inputs.self.modules.homeManager.${username} ];
      };

      system.primaryUser = username;

      users.users.${username} = {
        name = username;
        home = "/Users/${username}";
        shell = pkgs.zsh;
      };
    };
}
