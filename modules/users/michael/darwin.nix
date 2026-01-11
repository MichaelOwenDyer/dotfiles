{
  ...
}:
{
  # Darwin user configuration
  flake.modules.darwin.michael =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.darwin; [
        shell-zsh
      ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael ];
      };

      users.users.michael = {
        name = username;
        home = "/Users/michael";
        shell = pkgs.zsh;
      };
    };
}
