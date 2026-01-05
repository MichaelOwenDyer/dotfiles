{
  inputs,
  ...
}:
{
  flake.modules.nixos.rpi-3b =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager."michael@rpi-3b" ];
      };
    };

  # Host-specific home-manager configuration for michael on rpi-3b
  flake.modules.homeManager."michael@rpi-3b" =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
        gitui
        ide-helix
        yazi
        nh
      ];

      home.stateVersion = "25.11";
    };
}
