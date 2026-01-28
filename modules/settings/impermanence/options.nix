{ ... }:
{
  # Global impermanence options - should always be available regardless
  # of whether the impermanence module is imported.
  # This allows other modules to declare their persistence needs.
  #
  # When the impermanence module is imported, it consumes these options
  # to configure actual persistence. When it's not imported, these options
  # are simply ignored.

  flake.modules.nixos.impermanence-options =
    { lib, ... }:
    {
      options.impermanence = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether to enable impermanence.";
        };

        persistedFiles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Files to persist across reboots.";
        };

        persistedDirectories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Directories to persist across reboots.";
        };

        ignoredPaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Paths that are safe to lose (generated on boot, caches, etc).";
        };
      };
    };
}
