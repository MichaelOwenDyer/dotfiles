{
  inputs,
  ...
}:
{
  flake.modules.nixos.noctalia =
    { pkgs, ... }:
    {
      imports = [ inputs.noctalia.nixosModules.default ];
    };

  flake.modules.homeManager.noctalia =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia-shell = {
        enable = true;
        systemd.enable = true;
        plugins = {
          sources = [
            {
              enabled = true;
              name = "Official Noctalia Plugins";
              url = "https://github.com/noctalia-dev/noctalia-plugins";
            }
          ];
          states = {
            catwalk = {
              enabled = true;
              sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
            };
          };
          version = 1;
        };
      };

      # Spawn Noctalia Shell at Niri startup if systemd user unit is not enabled
      programs.niri.settings.spawn-at-startup = lib.mkIf (!programs.noctalia-shell.systemd.enable) [{
        command = [ "noctalia-shell" ];
      }];
    };
}