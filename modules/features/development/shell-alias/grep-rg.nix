{
  inputs,
  ...
}:
{
  flake.modules.nixos.shell-alias-grep-rg =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.ripgrep ];
      environment.shellAliases = {
        grep = "rg";
      };
    };

  flake.modules.darwin.shell-alias-grep-rg =
    { ... }:
    {
      imports = [ inputs.self.modules.darwin.ripgrep ];
      environment.shellAliases = {
        grep = "rg";
      };
    };

  flake.modules.homeManager.shell-alias-grep-rg =
    { ... }:
    {
      imports = [ inputs.self.modules.homeManager.ripgrep ];
      home.shellAliases = {
        grep = "rg";
      };
    };
}