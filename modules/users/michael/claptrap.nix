{
  inputs,
  ...
}:
{
  # Assign user michael to host claptrap with host-specific configuration

  flake.modules.nixos.michael-claptrap =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael-claptrap ];
      };
    };

  # Host-specific home-manager configuration for michael on claptrap
  flake.modules.homeManager.michael-claptrap =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        ide-vscode
        ide-cursor
        browser-chrome
        dank-material-shell
        niri
      ];

      home.stateVersion = "24.11";
    };
}
