{
  ...
}:
{
  # Pi coding agent (https://pi.dev) with declarative models.json / settings.json.
  #
  # The agent directory is ~/.pi/agent. Pi only *writes* settings.json, auth.json,
  # models-store.json, trust.json and sessions/; models.json is read-only, so it
  # is symlinked straight out of the nix store. settings.json and auth.json are
  # installed as regular files by an activation step so that pi can still write to
  # them between rebuilds -- a rebuild reinstates the declared state.

  # Decrypt the crowbot key for the user that runs pi, so the home-manager
  # module can read it with `!cat /run/secrets/crowbot-api-key` instead of
  # storing the key in auth.json. Import this next to the home-manager `pi`
  # module on NixOS hosts (owner is the interactive user).
  flake.modules.nixos.pi =
    { ... }:
    {
      sops.secrets."crowbot-api-key" = {
        owner = "michael";
        mode = "0400";
      };
    };

  flake.modules.homeManager.pi =
    { config, lib, pkgs, ... }:
    let
      cfg = config.programs.pi;

      agentDir = "${config.home.homeDirectory}/.pi/agent";

      mkModel = id: contextWindow: maxTokens: cost: {
        inherit id contextWindow maxTokens cost;
      };

      # Mirrors the previous hand-written ~/.pi/agent/models.json.
      crowbotModels = [
        (mkModel "kimi-k3-crow" 1000000 32800 {
          input = 6.0;
          cacheRead = 0.6;
          cacheWrite = 25.0;
          output = 25.0;
        })
        (mkModel "crow-2" 1000000 32800 {
          input = 3.5;
          cacheRead = 0.5;
          cacheWrite = 5.0;
          output = 5.0;
        })
        (mkModel "glm-5.3" 1000000 131000 {
          input = 1.35;
          cacheRead = 0.25;
          cacheWrite = 4.0;
          output = 4.0;
        })
        (mkModel "glm-5.3-flash-crow" 1000000 32800 {
          input = 0.2;
          cacheRead = 0.1;
          cacheWrite = 0.6;
          output = 0.6;
        })
        (mkModel "deepseek-v4.1-flash-1017-crow" 1000000 32800 {
          input = 0.35;
          cacheRead = 0.015;
          cacheWrite = 1.35;
          output = 1.35;
        })
        (mkModel "gpt-6.1-sol" 1000000 128000 {
          input = 0.16;
          cacheRead = 0.008;
          cacheWrite = 0.8;
          output = 0.8;
        })
        (mkModel "claude-opus-5-5" 1000000 128000 {
          input = 0.68;
          cacheRead = 0.034;
          cacheWrite = 3.4;
          output = 3.4;
        })
        (mkModel "kimi-k3.1-pro" 1000000 1000000 {
          input = 0.21;
          cacheRead = 0.021;
          cacheWrite = 1.05;
          output = 1.05;
        })
        (mkModel "deepseek-v4.1-flash" 1000000 128000 {
          input = 0.03;
          cacheRead = 0.0006;
          cacheWrite = 0.12;
          output = 0.12;
        })
        (mkModel "glm-5.3-cheap" 1000000 128000 {
          input = 0.07;
          cacheRead = 0.013;
          cacheWrite = 0.22;
          output = 0.22;
        })
        (mkModel "gemini-4-argon" 1000000 65500 {
          input = 0.3;
          cacheRead = 0.015;
          cacheWrite = 1.5;
          output = 1.5;
        })
        (mkModel "odin" 1000000 32800 {
          input = 0.6;
          cacheRead = 0.012;
          cacheWrite = 1.8;
          output = 1.8;
        })
        (mkModel "odin-cheap" 1000000 128000 {
          input = 0.05;
          cacheRead = 0.005;
          cacheWrite = 0.25;
          output = 0.25;
        })
        (mkModel "crow-1" 262000 32800 {
          input = 2.5;
          cacheRead = 0.25;
          cacheWrite = 3.0;
          output = 3.0;
        })
        (mkModel "claude-opus-5" 1000000 128000 {
          input = 0.15;
          cacheRead = 0.015;
          cacheWrite = 0.75;
          output = 0.75;
        })
        (mkModel "gpt-5.6-sol" 1000000 128000 {
          input = 0.24;
          cacheRead = 0.024;
          cacheWrite = 1.2;
          output = 1.2;
        })
      ];

      modelsConfig = {
        "$schema" = "https://pi.dev/schemas/models.schema.json";
        providers.crowbot = {
          baseUrl = "https://api.crowbot.sh/v1";
          api = "openai-completions";
          models = crowbotModels ++ cfg.extraModels;
        };
      };

      settingsConfig = lib.recursiveUpdate {
        defaultProvider = "crowbot";
        defaultModel = "deepseek-v4.1-flash";
      } cfg.settings;

      settingsFile = pkgs.writeText "pi-settings.json" (builtins.toJSON settingsConfig);

      authFile = pkgs.writeText "pi-auth.json" (
        builtins.toJSON {
          crowbot = {
            type = "api_key";
            key = cfg.apiKey;
          };
        }
      );

      configFileScript =
        ''
          run ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg agentDir}
          run ${pkgs.coreutils}/bin/install -m 600 ${settingsFile} ${lib.escapeShellArg "${agentDir}/settings.json"}
        ''
        + lib.optionalString (cfg.apiKey != null) ''
          run ${pkgs.coreutils}/bin/install -m 600 ${authFile} ${lib.escapeShellArg "${agentDir}/auth.json"}
        '';
    in
    {
      options.programs.pi = {
        apiKey = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "!cat /run/secrets/crowbot-api-key";
          description = ''
            Crowbot API key written to `auth.json`. Accepts anything pi resolves
            for a stored credential: a literal key, `$VAR`/''${VAR} environment
            interpolation, or `!command` whose stdout is the key (resolved lazily
            and cached for the process lifetime, so the key never hits disk).

            Leave null to keep `auth.json` unmanaged and let pi handle its own
            credentials, e.g. an existing key or `/login`.
          '';
        };

        extraModels = lib.mkOption {
          type = lib.types.listOf lib.types.attrs;
          default = [ ];
          description = "Additional crowbot models appended to the declared list.";
        };

        settings = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = "Extra settings.json entries, merged over the declared defaults.";
        };
      };

      config = {
        home.packages = [ pkgs.pi-coding-agent ];

        home.file."${agentDir}/models.json".text = builtins.toJSON modelsConfig;

        home.activation.piConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] configFileScript;
      };
    };
}
