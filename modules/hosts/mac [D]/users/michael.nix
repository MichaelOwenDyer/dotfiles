{
  inputs,
  ...
}:
{
  # Assign user michael to host mac

  flake.modules.darwin.mac =
    { ... }:
    {
      imports = [ inputs.self.modules.darwin.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager."michael@mac" ];
      };
    };

  # Host-specific home-manager configuration for michael on mac
  flake.modules.homeManager."michael@mac" =
    { lib, ... }:
    {
      imports = [ inputs.self.modules.homeManager.michael ];

      home.homeDirectory = lib.mkForce "/Users/michael";
      home.stateVersion = "24.11";
    };
}
