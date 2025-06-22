# Options which can be set by a user and used as part of a system configuration.
# Systems are not obligated to honor these settings.

{
  lib,
  pkgs,
  ...
}:

{
  options = with lib.types; {
    home-manager.users = lib.mkOption {
      type = attrsOf (submoduleWith {
        shorthandOnlyDefinesConfig = false;
        modules = [{
          options.systemIntegration = {
            username = lib.mkOption {
              type = str;
              description = "Username of the user";
            };
            description = lib.mkOption {
              type = nullOr str;
              default = null;
              description = "Description of the user";
            };
            hashedPassword = lib.mkOption {
              type = nullOr str;
              default = null;
              description = "Hashed password of the user";
            };
            shell = lib.mkOption {
              type = package;
              description = "Preferred shell of the user";
              default = pkgs.bash;
            };
            trustedSshKeys = lib.mkOption {
              type = listOf str;
              description = "List of SSH public keys which can log in as the user via SSH";
              default = [ ];
            };
          };
        }];
      });
    };
  };
}
