{
  inputs,
  ...
}:
{
  flake.modules.darwin.work =
    { ... }:
    {
      homebrew.casks = [
       "orbstack"
       "1password"
       "bruno"
       "slack"
       "jetbrains-toolbox"
     ];
    };

  flake.modules.homeManager.work =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        cli
        github-copilot-cli
        cursor-cli
        claude-code-cli
      ];

      home.packages = with pkgs; [
        openssh
        mysql84
        nodejs_24
        gh
        witr
      ];

      xdg.configFile = {
        "charon/config.yml".text = ''
          jumphost:
            host: jumphost.kredite.check24.de
            port: 42022
            user: michael.dyer
            identity_file: ~/.ssh/id_ed25519_sk

          tunnels:
            - name: host-test-db-01
              local_port: 3307
              remote_host: host-test-db-01.kredite.check24.de
              remote_port: 3306
            - name: host-prod-db-01
              local_port: 3309
              remote_host: host-prod-db-01.kredite.check24.de
              remote_port: 3306
            - name: host-prod-db-02
              local_port: 3310
              remote_host: host-prod-db-02.kredite.check24.de
              remote_port: 3306
        '';

        "db-importer.yaml".text = ''
          # db-importer configuration
          defaults:
            local_host: 127.0.0.1
            local_port: 3306
            local_user: root
            local_password: root
            target_db: app_prod-clone
            charon_config: "~/.config/charon/config.yml"
            exclude_tables:
              - file
            # migration_table: doctrine_migration_versions

          environments:
            - name: prod
              charon_tunnel: host-prod-db-02
              remote_db: mono_prod
              op_username: "op://03 - Production/PM Database-User PROD/username"
              op_password: "op://03 - Production/PM Database-User PROD/password"
        '';
      };
    };
}
