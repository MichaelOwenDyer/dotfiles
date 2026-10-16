{
  inputs,
  ...
}:
{
  flake.modules.nixos.noctalia-shell =
    { ... }:
    {
      imports = [ inputs.noctalia.nixosModules.default ];
    };

  flake.modules.homeManager.noctalia-shell =
    { ... }:
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
    };
}
