{
  pkgs,
  ...
}:

{
  programs.helix = {
    enable = true;
    package = pkgs.evil-helix; # Evil Helix has standard Vim keybinds
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
    extraConfig = ''
      [keys.normal]
      esc = ["collapse_selection", "keep_primary_selection"]

      [keys.normal.space]
      q = ":q"
      space = "file_picker"
      w = ":w"
    '';
  };
  home.sessionVariables.EDITOR = "hx";
}
