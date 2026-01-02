{
  inputs,
  ...
}:
{
  # Desktop environment - extends system-cli with desktop-related features

  flake.modules.nixos.system-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        system-cli
        audio
      ];

      environment.systemPackages = with pkgs; [
        gparted
      ];

      # Enable XDG desktop portal
      xdg.portal.enable = true;

      programs.dconf.enable = true;
      security.polkit.enable = true;
    };

  flake.modules.darwin.system-desktop = {
    imports = with inputs.self.modules.darwin; [
      system-cli
    ];
  };

  flake.modules.homeManager.system-desktop = {
    imports = with inputs.self.modules.homeManager; [
      system-cli
      development
      shell-fish
    ];
  };
}
