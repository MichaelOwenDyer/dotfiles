{
  inputs,
  ...
}:
{
  # Development tools and configuration

  flake.modules.homeManager.development =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        git
        gitui
        direnv
        ghostty
        fzf
        jujutsu
        nix-lang
        cursor-cli
        shell-alias-cd-zoxide
        eza
        bat
        fd
        ripgrep
      ];

      home.packages = with pkgs; [
        xh
        dust
        dysk
        wl-clipboard
        lazyjj
        zellij
        fastfetch
      ];
    };
}
