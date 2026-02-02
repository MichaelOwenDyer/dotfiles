{
  inputs,
  ...
}:
{
  flake.modules.darwin.work =
    { ... }:
    {
      imports = with inputs.self.modules.darwin; [
        _1password
      ];
    };

  flake.modules.homeManager.work =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        cli
        cursor-cli
        orbstack
      ];
    };
}