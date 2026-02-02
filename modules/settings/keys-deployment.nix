{
  inputs,
  ...
}:
{
  # Deploy cryptographic keys from sops to filesystem at boot

  flake.modules.nixos.keys-deployment =
    { lib, config, ... }:
    let
      cfg = config.keys.deployment;
      keys = inputs.self.lib.keys;

      userKeyConfigs = builtins.filter (k: k.privateKeySecret != null)
        (map (name: keys.ssh.user.${name}) cfg.userKeys);
      rootKeyConfigs = map (name: keys.ssh.root.${name}) cfg.rootKeys;
      signingKeyConfigs = map (name: keys.signing.${name}) cfg.signingKeys;

      allSecrets = map (k: k.privateKeySecret)
        (userKeyConfigs ++ rootKeyConfigs ++ signingKeyConfigs);

      mkDeployService = name: keyConfigs: lib.mkIf (keyConfigs != [ ]) {
        description = "Deploy ${name} from sops";
        wantedBy = [ "multi-user.target" ];
        after = [ "sops-nix.service" ];
        requires = [ "sops-nix.service" ];
        serviceConfig = { Type = "oneshot"; RemainAfterExit = true; };
        script = lib.concatMapStringsSep "\n" (k:
          let
            secretPath = config.sops.secrets.${k.privateKeySecret}.path;
            dir = dirOf k.deployPath;
          in ''
            mkdir -p "${dir}" && chmod 700 "${dir}"
            ${lib.optionalString (k.owner != "root") ''chown ${k.owner}:${k.owner} "${dir}"''}
            install -m 600 -o ${k.owner} -g ${k.owner} "${secretPath}" "${k.deployPath}"
            echo "${k.pub}" > "${k.deployPath}.pub"
            chmod 644 "${k.deployPath}.pub"
          '') keyConfigs;
      };
    in
    {
      options.keys.deployment = {
        userKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
        rootKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
        signingKeys = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };

      config = lib.mkIf (allSecrets != [ ]) {
        sops.secrets = builtins.listToAttrs (map (s: { name = s; value = { }; }) allSecrets);

        systemd.services.deploy-user-ssh-keys = mkDeployService "user SSH keys" userKeyConfigs;
        systemd.services.deploy-root-ssh-keys = mkDeployService "root SSH keys" rootKeyConfigs;
        systemd.services.deploy-signing-keys = mkDeployService "signing keys" signingKeyConfigs;

        impermanence.ephemeralPaths = lib.mkIf (config.impermanence.enable or false)
          (map (k: dirOf k.deployPath) userKeyConfigs);
      };
    };
}
