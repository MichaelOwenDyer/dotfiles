{
  inputs,
  ...
}:
{
  # Openclaw - Personal AI Assistant
  # https://github.com/openclaw/nix-openclaw
  #
  # This module provides:
  # - NixOS service configuration (user, firewall, impermanence)
  # - Home Manager wrapper with simplified options
  # - sops-nix integration for secrets management

  # NixOS module for openclaw system configuration
  flake.modules.nixos.openclaw =
    { config, lib, ... }:
    let
      cfg = config.openclaw;
    in
    {
      imports = [ inputs.self.modules.nixos.openclaw-secrets ];

      options.openclaw = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable openclaw";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 18789;
          description = "Port for the openclaw gateway.";
        };

        openFirewall = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to open the firewall for the gateway port.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "openclaw";
          description = "User account under which openclaw runs.";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "openclaw";
          description = "Group under which openclaw runs.";
        };
      };

      config = lib.mkMerge [
        {
          # Persist openclaw state with impermanence
          impermanence.persistedDirectories = [
            "/var/lib/openclaw"
          ];
        }
        {
          users.users.${cfg.user} = {
            isSystemUser = true;
            group = cfg.group;
            description = "Openclaw AI assistant service user";
          };

          users.groups.${cfg.group} = { };

          networking.firewall = lib.mkIf cfg.openFirewall {
            allowedTCPPorts = [ cfg.port ];
          };
        }
      ];
    };

  # Home Manager module - wrapper around upstream programs.openclaw
  flake.modules.homeManager.openclaw =
    { config, lib, ... }:
    let
      cfg = config.openclaw;
    in
    {
      imports = [ inputs.self.modules.homeManager.openclaw-secrets inputs.nix-openclaw.homeManagerModules.openclaw ];

      options.openclaw = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to enable openclaw";
        };

        telegram = {
          enable = lib.mkEnableOption "Telegram channel";

          botTokenFile = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Path to file containing Telegram bot token.";
          };

          allowedChatIds = lib.mkOption {
            type = lib.types.listOf lib.types.int;
            default = [ ];
            description = "List of Telegram chat IDs allowed to interact with the bot.";
          };
        };

        plugins = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
          description = "List of plugin sources to enable.";
          example = ''[ { source = "github:openclaw/nix-steipete-tools?dir=tools/summarize"; } ]'';
        };

        model = lib.mkOption {
          type = lib.types.str;
          default = "anthropic/claude-sonnet-4-5";
          description = ''
            Primary model to use.
            Examples: anthropic/claude-3-5-haiku-latest, anthropic/claude-sonnet-4-5, anthropic/claude-opus-4
          '';
        };
      };

      config =
        let
          # Generate a deterministic token from the hostname for gateway auth
          # This avoids the "token not configured" error while keeping it simple
          gatewayToken = builtins.hashString "sha256" "openclaw-gateway-${config.home.username}";

          # Shared config used by both global and instance settings
          # Duplicated due to upstream nix-openclaw bugs (see comment below)
          openclawConfig = {
            gateway = {
              mode = "local";
              auth.token = gatewayToken;
            };

            commands = {
              native = "auto";
              nativeSkills = "auto";
            };

            channels.telegram = {
              enabled = true;
              tokenFile = cfg.telegram.botTokenFile;
              allowFrom = cfg.telegram.allowedChatIds;
              dmPolicy = "pairing";
              groupPolicy = "allowlist";
              streamMode = "partial";
            };

            plugins.entries.telegram.enabled = true;

            agents.defaults = {
              maxConcurrent = 4;
              subagents.maxConcurrent = 8;
              model.primary = cfg.model;
            };

            messages.ackReactionScope = "group-mentions";
          };
        in
        {
          programs.openclaw = {
            enable = cfg.enable;

            config = openclawConfig;

            plugins = cfg.plugins;

            # Workaround for upstream nix-openclaw bugs:
            # 1. cfg.systemd only has 'enable' but instance expects 'unitName' too
            #    (defaultInstance passes cfg.systemd directly to instance)
            # 2. Setting instances causes module system to initialize config submodule
            #    with null defaults that override cfg.config via lib.recursiveUpdate
            #
            # Solution: Explicitly set instances.default with the same config values.
            # The config must be duplicated because the instance's config submodule
            # initializes all options to null by default.
            instances.default = {
              enable = true;
              config = openclawConfig;
            };
          };
        };
    };
}
