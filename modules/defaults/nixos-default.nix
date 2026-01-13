{
  inputs,
  ...
}:
{
  # Default settings needed for all nixosConfigurations

  flake.modules.nixos.default-settings = {
    imports = with inputs.self.modules.nixos; [
      overlays
      nh
    ];

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      trusted-users = [
        "root"
        "@wheel"
      ];
    };

    nix.extraOptions = ''
      warn-dirty = false
    '';

    # Localization defaults
    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Berlin";
    console.font = "Lat2-Terminus16";

    # enables unpatched dynamic binaries to run and find the libs they need
    programs.nix-ld.enable = true;

    # nftables is the modern packet filtering framework
    networking.nftables.enable = true;

    # broker dbus implementation is faster and more secure
    services.dbus.implementation = "broker";
  };
}
