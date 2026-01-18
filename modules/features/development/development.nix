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
        yazi
        zoxide
        fzf
        jujutsu
        nix-lang
        cursor-cli
        shell-alias-cd-zoxide
        shell-alias-ls-eza
        shell-alias-cat-bat
        shell-alias-find-fd
        shell-alias-grep-rg
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
