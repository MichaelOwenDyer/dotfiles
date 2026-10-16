{
  ...
}:
{
  # Zsh shell configuration

  flake.modules.homeManager.zsh-shell =
    { ... }:
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
      };
    };

  flake.modules.nixos.zsh-shell = {
    programs.zsh.enable = true;
  };

  flake.modules.darwin.zsh-shell = {
    programs.zsh.enable = true;
  };
}
