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
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        niri
        dank-material-shell
        ide-vscode
        ide-cursor
        zen-browser
      ];

      home.stateVersion = "24.11";
    };
}
