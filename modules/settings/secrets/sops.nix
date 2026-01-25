{
  inputs,
  lib,
  ...
}:
{
  # sops-nix secrets management
  # https://github.com/Mic92/sops-nix

  flake.modules.nixos.sops =
    { config, ... }:
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.sops.ageKeyFile = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = "/etc/ssh/ssh_host_ed25519_key";
        description = "Path to the age-compatible private key for decrypting secrets and editing with sops CLI.";
      };

      config = {
        sops = {
          defaultSopsFile = ./secrets.yaml;
          age.sshKeyPaths = [ config.sops.ageKeyFile ];
        };

        # Set SOPS_AGE_SSH_KEY so `sops` CLI uses the same key for editing
        environment.variables.SOPS_AGE_SSH_KEY = toString config.sops.ageKeyFile;
      };
    };
}
