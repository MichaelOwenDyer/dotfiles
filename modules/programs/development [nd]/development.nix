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
      ];

      # Better cd
      programs.zoxide.enable = true;

      # Fuzzy file search
      programs.fzf.enable = true;

      # Enhanced cat
      programs.bat.enable = true;

      # Terminal file browser
      programs.yazi.enable = true;

      # Modern VCS
      programs.jujutsu.enable = true;

      home.packages = with pkgs; [
        nixd
        nixfmt-rfc-style
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
        jq
        fastfetch
      ];

      home.shellAliases = {
        cd = "z";
        ls = "eza";
        ycut = "${pkgs.yt-dlp}/bin/yt-dlp --external-downloader ${pkgs.ffmpeg}/bin/ffmpeg --external-downloader-args \"ffmpeg_i:-ss $1 -to $2\"";
      };
    };
}
