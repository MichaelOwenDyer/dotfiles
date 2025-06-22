{
  wayland ? true,
  username ? "michael",
  name ? "Michael Dyer",
  email ? "michaelowendyer@gmail.com",
  hashedPassword ? "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1",
}:

{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./ide/helix.nix
    (import ./development.nix { inherit name email; })
    (import ./shell/fish.nix { })
  ];

  config = {
    systemIntegration = {
      inherit username hashedPassword;
      description = name;
      shell = pkgs.fish;
      trustedSshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINj8NsgxdKFSwaLN5cK2vebcfdWTI39OoAutnMI9awyD michael@rustbucket"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINtKFTvyCJo4u7KstzHIZ/ZdBCfS5ukmItX75tC0aM5O michael@claptrap"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE1RmSKMqa9vAqyHjJzEmjFOJYV+qT/imHpXDmeWl6PI michael@rpi-3b"
      ];
    };

    # I LOVE U; assert iloveyoutoo == true;
    programs.home-manager.enable = true;
    services.home-manager.autoExpire = {
      enable = true;
      frequency = "monthly";
      timestamp = "-30 days";
      store.cleanup = true;
    };
    home = {
      inherit username;
      homeDirectory = "/home/${username}";
      sessionVariables = lib.mkMerge [
        { NIXPKGS_ALLOW_UNFREE = "1"; }
        (lib.mkIf wayland { NIXOS_OZONE_WL = "1"; GTK_USE_PORTAL = "1"; })
      ];
    };
  };
}
