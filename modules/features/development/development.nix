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
        nix-lang
        cursor-cli
        shell-alias-cd-zoxide
        eza
        bat
        fd
        ripgrep
      ];

      home.packages = with pkgs; [
        wl-clipboard
        fastfetch
      ];
    };
}
