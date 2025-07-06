# Common configuration for NixOS machines.

{
  hostname,
  users,
}:

{
  lib,
  pkgs,
  config,
  ...
} @ inputs:

{
  networking.hostName = hostname;
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";
  console.font = "Lat2-Terminus16";
  
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    ripgrep
    gparted
    tree
    openssh
    gnupg1
    evil-helix
  ];
  
  home-manager.users = lib.mapAttrs (username: home: import home inputs) users;
  users.users =
    lib.mapAttrs
    (
      username: home:
      {
        isNormalUser = true;
        description = home.systemIntegration.description;
        hashedPassword = home.systemIntegration.hashedPassword;
        shell = home.systemIntegration.shell;
        extraGroups = [
          # TODO: need better system for assigning groups
          "wheel"
          "video"
          "audio"
          "input"
          "networkmanager"
        ];
        openssh.authorizedKeys.keys = home.systemIntegration.trustedSshKeys;
      }
    )
    config.home-manager.users;

  # enable shells for users to use
  programs.fish.enable = true;

  # Run garbage collection weekly
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
    };
    extraOptions = "warn-dirty = false";
  };

  # Enable SSH
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      UseDns = true;
      UsePAM = true;
    };
  };

  # nftables is the modern packet filtering framework
  networking.nftables.enable = true;

  # broker dbus implementation is faster and more secure than the original
  services.dbus.implementation = "broker";
}
