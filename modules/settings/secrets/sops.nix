{
  inputs,
  ...
}:
{
  # sops-nix secrets management
  # https://github.com/Mic92/sops-nix

  flake.modules.nixos.sops =
    { config, lib, pkgs, ... }:
    let
      # When impermanence is enabled, SSH keys live in /persist and are bind-mounted.
      # sops-nix runs before bind mounts, so we point directly to /persist.
      sshKeyPath =
        if config.impermanence.enable then
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
        description = "Path to the SSH private key used for decrypting secrets.";
      };

      config = {
        sops = {
          defaultSopsFile = ./secrets.yaml;
          age.sshKeyPaths = [ config.sops.ageKeyFile ];
        };

        environment.systemPackages = with pkgs; [
          sops
          ssh-to-age
          (writeShellScriptBin "sops-edit" ''
            export SOPS_AGE_KEY=$(${ssh-to-age}/bin/ssh-to-age -private-key < ~/.ssh/id_ed25519)
            exec ${sops}/bin/sops "''${1:-${./secrets.yaml}}"
          '')
        ];
      };
    };
}
