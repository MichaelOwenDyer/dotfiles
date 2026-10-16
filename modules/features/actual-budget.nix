{
  inputs,
  ...
}:
{
  # Actual Budget - Privacy-focused personal finance app
  # https://actualbudget.org/

  flake.modules.nixos.actual-budget =
    { config, lib, ... }:
    let
      cfg = config.actual-budget;
    in
    {
      key = "actual-budget";

      imports = with inputs.self.modules.nixos; [
        cloudflare-tunnel
      ];

      options.actual-budget = {
        subdomain = lib.mkOption {
          type = lib.types.str;
          default = "budget";
          description = "Subdomain for Actual Budget on Cloudflare Tunnel (e.g. 'budget')";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 5006;
          description = "Internal web interface port for Actual Budget";
        };

        address = lib.mkOption {
          type = lib.types.str;
          default = "127.0.0.1";
          description = "Address to bind Actual Budget server to";
        };
      };

      config = {
        services.actual = {
          enable = true;
          settings = {
            hostname = cfg.address;
            port = cfg.port;
          };
        };

        cloudflare-tunnel.proxiedServices.actual-budget = {
          subdomain = cfg.subdomain;
          forwardTo = "http://${cfg.address}:${toString cfg.port}";
        };

        impermanence.persistedDirectories = [
          config.services.actual.settings.dataDir
        ];
      };
    };
}
