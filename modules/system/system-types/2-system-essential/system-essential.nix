{
  inputs,
  ...
}:
{
  # Import all essential nix-tools which are used in all modules of specific class

  flake.modules.nixos.system-essential = {
    imports =
      with inputs.self.modules.nixos;
      [
        system-default
        overlays
        home-manager
        stylix
      ];
  };

  flake.modules.darwin.system-essential = {
    imports =
      with inputs.self.modules.darwin;
      [
        system-default
        overlays
        home-manager
      ];
  };

  flake.modules.homeManager.system-essential = {
    imports =
      with inputs.self.modules.homeManager;
      [
        system-default
        stylix
      ];
  };
}
