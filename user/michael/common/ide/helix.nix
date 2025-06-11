{
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
    };
  };
}
