{
  pkgs,
  lib,
  name,
  email,
  ...
}:

{
  programs.git = {
    enable = true;
    userName = name;
    userEmail = email;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      url = {
        "https://github.com" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    silent = true;
    nix-direnv.enable = true;
  };
  programs.neovim.enable = true;
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };
  home.packages = with pkgs; [
    nixd # Nix LSP
    nixfmt-rfc-style # Nix formatting
    rustup
  ];
}