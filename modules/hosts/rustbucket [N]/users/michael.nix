{
  inputs,
  ...
}:
{
  # Assign user michael to host rustbucket with host-specific configuration

  flake.modules.nixos.rustbucket =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager."michael@rustbucket" ];
      };

      # Override default hashed password for this host
      users.users.michael.hashedPassword = "$y$j9T$toiC/s1uug/kKiuVcZxRB.$GXHVFF1L1wyOfdDMk647N7YkUxbaSFwnc4aSMSVa.88";
    };

  # Host-specific home-manager configuration for michael on rustbucket
  flake.modules.homeManager."michael@rustbucket" =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        stylix-config
        ide-vscode
        ide-cursor
        browser-zen
      ];

      home.stateVersion = "24.11";
    };
}
