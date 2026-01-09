{
  inputs,
  ...
}:
{
  flake.modules.nixos.shell-alias-ls-eza =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.eza ];
      environment.shellAliases = {
        ls = "eza";
      };
    };

  flake.modules.darwin.shell-alias-ls-eza =
    { ... }:
    {
      imports = [ inputs.self.modules.darwin.eza ];
      environment.shellAliases = {
        ls = "eza";
      };
    };

  flake.modules.homeManager.shell-alias-ls-eza =
    { ... }:
    {
      imports = [ inputs.self.modules.homeManager.eza ];
      home.shellAliases = {
        ls = "eza";
      };
    };
}