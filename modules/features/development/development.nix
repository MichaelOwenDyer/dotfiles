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
        shell-alias-cd-zoxide
        shell-alias-ls-eza
        shell-alias-cat-bat
        shell-alias-find-fd
      ];

      home.packages = with pkgs; [
        ripgrep
        ripgrep-all
        fd
        eza
        xh
        dust
        dysk
        wl-clipboard
        lazyjj
        zellij
        fastfetch
      ];

      home.shellAliases = {
        cd = "z";
        ls = "eza";
        ycut = "${pkgs.yt-dlp}/bin/yt-dlp --external-downloader ${pkgs.ffmpeg}/bin/ffmpeg --external-downloader-args \"ffmpeg_i:-ss $1 -to $2\"";
      };
    };
}
