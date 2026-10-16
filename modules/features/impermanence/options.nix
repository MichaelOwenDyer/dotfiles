{ ... }:
{
  # Global impermanence options - available even when impermanence module isn't imported
  flake.modules.nixos.impermanence-options =
    { lib, ... }:
    {
      options.impermanence = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Enable impermanence.";
        };

        persistedFiles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Files to persist.";
        };

        persistedDirectories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Directories to persist.";
        };

        ephemeralPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Paths acknowledged as ephemeral.";
        };
      };
    };
}
