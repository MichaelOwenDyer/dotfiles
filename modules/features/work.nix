{
  inputs,
  ...
}:
{
  flake.modules.darwin.work =
    { ... }:
    {
      homebrew.casks = [
       "orbstack"
       "1password"
       "bruno"
       "slack"
       "jetbrains-toolbox"
     ];
    };

  flake.modules.homeManager.work =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        cli
        github-copilot-cli
        cursor-cli
        claude-code-cli
      ];

      home.packages = with pkgs; [
        nodejs_24
        gh
        witr
      ];
    };
}
