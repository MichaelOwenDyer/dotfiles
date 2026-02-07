{
  ...
}:
{
  # Ghostty terminal emulator

  flake.modules.nixos.ghostty = {
    programs.ghostty.enable = true;
  };

  flake.modules.darwin.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
      };
    };

  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

        settings = {
          theme = "Catppuccin Mocha";
          working-directory = "~/.dotfiles";

          font-family = "JetBrainsMono Nerd Font";
          font-size = 12;
          font-feature = [ "calt" "liga" ]; # Ligatures

          cursor-style = "bar";
          cursor-style-blink = false;

          mouse-hide-while-typing = true;
          copy-on-select = "clipboard";
          scrollback-limit = 50000;

          window-padding-x = 8;
          window-padding-y = 8;
          window-decoration = false; # Let window manager handle decorations

          confirm-close-surface = true;
          shell-integration = "fish";
          gtk-single-instance = true;

          keybind = [
            "ctrl+plus=increase_font_size:1"
            "ctrl+minus=decrease_font_size:1"
            "ctrl+zero=reset_font_size"

            "ctrl+shift+enter=new_split:right"
            "ctrl+shift+s=new_split:down"
            "ctrl+shift+h=goto_split:left"
            "ctrl+shift+l=goto_split:right"
            "ctrl+shift+k=goto_split:top"
            "ctrl+shift+j=goto_split:bottom"

            "ctrl+shift+t=new_tab"
            "ctrl+shift+w=close_surface"
            "ctrl+tab=next_tab"
            "ctrl+shift+tab=previous_tab"

            "shift+page_up=scroll_page_up"
            "shift+page_down=scroll_page_down"
            "ctrl+shift+home=scroll_to_top"
            "ctrl+shift+end=scroll_to_bottom"
          ];
        };
      };
    };
}
