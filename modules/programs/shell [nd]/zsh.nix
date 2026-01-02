{
  inputs,
  ...
}:
{
  # Zsh shell configuration

  flake.modules.homeManager.shell-zsh =
    { pkgs, ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
      };
    };

  flake.modules.nixos.shell-zsh = {
    programs.zsh.enable = true;
  };

  flake.modules.darwin.shell-zsh = {
    programs.zsh.enable = true;
  };
}
