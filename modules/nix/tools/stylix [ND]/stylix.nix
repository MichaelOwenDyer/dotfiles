{
  inputs,
  ...
}:
{
  flake.modules.nixos.stylix = {
    imports = [
      inputs.stylix.nixosModules.stylix
    ];
  };

  flake.modules.darwin.stylix = {
    imports = [
      inputs.stylix.darwinModules.stylix
    ];
  };

  flake.modules.homeManager.stylix = {
    imports = [
      inputs.stylix.homeModules.stylix
    ];
  };
}
