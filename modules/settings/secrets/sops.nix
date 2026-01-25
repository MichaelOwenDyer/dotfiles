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
    let
      # When impermanence is enabled, SSH keys live in /persist and are bind-mounted.
      # sops-nix runs before bind mounts, so we point directly to /persist.
      sshKeyPath =
        if config ? impermanence && config.impermanence.enable then
          "${config.impermanence.persistPath}/etc/ssh/ssh_host_ed25519_key"
        else
          "/etc/ssh/ssh_host_ed25519_key";
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.sops.ageKeyFile = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = sshKeyPath;
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
