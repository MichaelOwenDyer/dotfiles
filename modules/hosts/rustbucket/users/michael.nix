{
  inputs,
  ...
}:
{
  # Assign user michael to host rustbucket with host-specific configuration

  flake.modules.nixos.michael-rustbucket =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael-rustbucket ];
      };
    };

  # Host-specific home-manager configuration for michael on rustbucket
  flake.modules.homeManager.michael-rustbucket =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        niri
        niri-outputs-rustbucket
        dank-material-shell
        idle
        ide-vscode
        ide-cursor
        zen-browser
        development
      ];

      services.idle = {
        displayTimeout = 300;
        lockTimeout = 600;
      };

      home.stateVersion = "24.11";
    };
}
