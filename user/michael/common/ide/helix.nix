{
  lib,
  pkgs,
  ...
}:

{
  programs.helix = {
    enable = true;
    package = pkgs.evil-helix; # Evil Helix has standard Vim keybinds
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
      C-y = [
        ':sh rm -f /tmp/unique-file',
        ':insert-output yazi %{buffer_name} --chooser-file=/tmp/unique-file',
        ':insert-output echo "\x1b[?2004h" > /dev/tty',
        ':open %sh{cat /tmp/unique-file}',
        ':redraw',
      ]

      [keys.normal.space]
      q = ":q"
      space = "file_picker"
      w = ":w"
    '';
  };
}
