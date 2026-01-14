{
  inputs,
  ...
}:
{
  # Darwin user configuration
  flake.modules.darwin.michael =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        home-manager
        zsh-shell
      ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael ];
      };
    };
}
