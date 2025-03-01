_:

{
  imports = [
    ./browser.nix
    ./development
  ];

  config.profiles.michael = rec {
    fullName = "Michael Dyer";
    email = "michaelowendyer@gmail.com";
    hashedPassword = "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
    ];
    caffeine.enable = true;
  };
}
