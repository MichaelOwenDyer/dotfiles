{
  lib,
  pkgs,
  ...
}:

{
  programs.helix = {
    enable = true;
    # package = pkgs.evil-helix; # Evil Helix has standard Vim keybinds
    # Add language servers without putting them on the path
    extraPackages = with pkgs; [
      yaml-language-server
      typescript-language-server
      # simple-completion-language-server would need to configure for every file type
      java-language-server
      docker-language-server
      # copilot-language-server currently no support
      bash-language-server
      rust-analyzer
    ];
    defaultEditor = true;
    settings = {
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
    };
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.nixfmt-rfc-style;
      }
    ];
    extraConfig = ''
      [keys.normal]
      esc = ["collapse_selection", "keep_primary_selection"]

      [keys.normal.space]
      q = ":q"
      space = "file_picker"
      w = ":w"
    '';
  };
  home.sessionVariables = {
    "EDITOR" = "hx";
  };
}
