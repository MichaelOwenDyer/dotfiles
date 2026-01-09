{
  inputs,
  ...
}:
{
  flake.modules.nixos.shell-alias-cd-zoxide =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.zoxide ];
      environment.shellAliases = {
        cd = "z";
      };
    };

  flake.modules.darwin.shell-alias-cd-zoxide =
    { ... }:
    {
      imports = [ inputs.self.modules.darwin.zoxide ];
      environment.shellAliases = {
        cd = "z";
      };
    };

  flake.modules.homeManager.shell-alias-cd-zoxide =
    { ... }:
    {
      imports = [ inputs.self.modules.homeManager.zoxide ];
      home.shellAliases = {
        cd = "z";
      };
    };
}