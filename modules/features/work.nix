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
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        cli
        cursor-cli
        orbstack
        bruno
      ];

      home.packages = with pkgs; [
        nodejs_24
        pnpm_9
      ];
    };
}
