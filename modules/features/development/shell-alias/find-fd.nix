{
  inputs,
  ...
}:
{
  flake.modules.nixos.shell-alias-find-fd =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.fd ];
      environment.shellAliases = {
        find = "fd";
      };
    };

  flake.modules.darwin.shell-alias-find-fd =
    { ... }:
    {
      imports = [ inputs.self.modules.darwin.fd ];
      environment.shellAliases = {
        find = "fd";
      };
    };

  flake.modules.homeManager.shell-alias-find-fd =
    { ... }:
    {
      imports = [ inputs.self.modules.homeManager.fd ];
      home.shellAliases = {
        find = "fd";
      };
    };
}