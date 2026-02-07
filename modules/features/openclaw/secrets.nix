{
  ...
}:
{
  # Openclaw secrets management via sops-nix
  #
  # Required secrets in modules/settings/secrets/secrets.yaml:
  #   anthropic-api-key: "sk-ant-..."
  #   telegram-bot-api-key: "123456:ABC..."

  flake.modules.nixos.openclaw-secrets =
    { config, ... }:
    {
      config = {
        # Secrets readable by michael since openclaw runs as a Home Manager user service
        sops.secrets = {
          "anthropic-api-key" = {
            owner = "michael";
            mode = "0400";
          };

          "telegram-bot-api-key" = {
            owner = "michael";
            mode = "0400";
          };
        };

        # Create environment file template that injects the API key
        sops.templates."openclaw-env" = {
          owner = "michael";
          content = ''
            ANTHROPIC_API_KEY=${config.sops.placeholder."anthropic-api-key"}
          '';
        };
      };
    };

  # Home Manager secrets integration
  flake.modules.homeManager.openclaw-secrets =
    { config, lib, osConfig, ... }:
    {
      config = lib.mkIf config.openclaw.enable {
        openclaw.telegram.botTokenFile = lib.mkDefault osConfig.sops.secrets."telegram-bot-api-key".path;

        # Anthropic API key is set via environment variable loaded from sops template
        systemd.user.services.openclaw-gateway.Service.EnvironmentFile = osConfig.sops.templates."openclaw-env".path;
      };
    };

  # Telegram user IDs for allowed chat access
  flake.lib.openclaw.telegramUserIds = {
    michael = 2043770539;
  };
}
