{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./browser.nix
    ./stylix.nix
    ./development
  ];

  config.profiles.michael = {
    fullName = "Michael Dyer";
    email = "michaelowendyer@gmail.com";
    hashedPassword = lib.mkDefault "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
    ];
    wayland.enable = true;
    caffeine.enable = true;
    # I LOVE U; assert iloveyoutoo == true;
  };
}
