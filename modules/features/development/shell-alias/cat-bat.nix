{
  inputs,
  ...
}:
{
  flake.modules.nixos.shell-alias-cat-bat =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.bat ];
      environment.shellAliases = {
        cat = "bat";
      };
    };

  flake.modules.darwin.shell-alias-cat-bat =
    { ... }:
    {
      imports = [ inputs.self.modules.darwin.bat ];
      environment.shellAliases = {
        cat = "bat";
      };
    };

  flake.modules.homeManager.shell-alias-cat-bat =
    { ... }:
    {
      imports = [ inputs.self.modules.homeManager.bat ];
      home.shellAliases = {
        cat = "bat";
      };
    };
}