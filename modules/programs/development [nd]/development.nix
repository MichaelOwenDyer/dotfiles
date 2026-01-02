{
  inputs,
  ...
}:
{
  # Development tools and configuration

  flake.modules.homeManager.development =
    { pkgs, config, ... }:
    {
      programs.git = {
        enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          pull.rebase = true;
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

      # Terminal
      programs.ghostty.enable = true;

      # Run commands when entering a directory
      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
      };

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

      # Git UI
      programs.gitui = {
        enable = true;
        keyConfig = ''
          move_left: Some(( code: Char('h'), modifiers: ( bits: 0,),)),
          move_right: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
          move_up: Some(( code: Char('k'), modifiers: ( bits: 0,),)),
          move_down: Some(( code: Char('j'), modifiers: ( bits: 0,),)),

          stash_open: Some(( code: Char('l'), modifiers: ( bits: 0,),)),
          open_help: Some(( code: F(1), modifiers: "")),

          status_reset_item: Some(( code: Char('U'), modifiers: "SHIFT")),

          exit: Some(( code: Char('c'), modifiers: ( bits: 2,),)),
          quit: Some(( code: Char('q'), modifiers: ( bits: 0,),)),
          exit_popup: Some(( code: Esc, modifiers: ( bits: 0,),)),
        '';
      };

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
      ];

      home.shellAliases = {
        cd = "z";
        ls = "eza";
      };
    };
}
