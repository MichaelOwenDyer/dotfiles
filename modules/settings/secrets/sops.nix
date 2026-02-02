{
  inputs,
  ...
}:
{
  # sops-nix secrets management

  flake.modules.nixos.sops =
    { config, lib, pkgs, ... }:
    let
      sshKeyPath =
        if config.impermanence.enable or false
        then "${config.impermanence.persistPath}/etc/ssh/ssh_host_ed25519_key"
        else "/etc/ssh/ssh_host_ed25519_key";
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      options.sops.ageKeyFile = lib.mkOption {
        type = lib.types.oneOf [
          lib.types.str
          lib.types.path
        ];
        default = sshKeyPath;
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
            set -e
            export SOPS_AGE_KEY=$(${ssh-to-age}/bin/ssh-to-age -private-key < ~/.ssh/id_ed25519)
            exec ${sops}/bin/sops "''${1:-${./secrets.yaml}}"
          '')
          (writeShellScriptBin "sops-updatekeys" ''
            set -e
            SECRETS_FILE="''${1:-${./secrets.yaml}}"
            export SOPS_AGE_KEY=$(${ssh-to-age}/bin/ssh-to-age -private-key < ~/.ssh/id_ed25519)
            cd "$(dirname "$SECRETS_FILE")"
            exec ${sops}/bin/sops updatekeys "$(basename "$SECRETS_FILE")"
          '')
          (writeShellScriptBin "sops-age-key" ''
            echo "User key:"; ${ssh-to-age}/bin/ssh-to-age < ~/.ssh/id_ed25519.pub
            echo "Host key:"; ${ssh-to-age}/bin/ssh-to-age < /etc/ssh/ssh_host_ed25519_key.pub
          '')
        ];
      };
    };
}
