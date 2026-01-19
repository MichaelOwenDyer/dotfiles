{
  ...
}:
{
  # Ghostty terminal emulator - fast, GPU-accelerated, native Wayland

  flake.modules.nixos.ghostty = {
    programs.ghostty = {
      enable = true;
    };
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
          # Theme matching your Catppuccin setup
          theme = "Catppuccin Mocha";

          # Font configuration
          # Benefit: Consistent with your terminal aesthetic
          font-family = "JetBrainsMono Nerd Font";
          font-size = 12;

          # Enable ligatures for programming fonts
          # Benefit: -> becomes →, != becomes ≠, etc.
          font-feature = [
            "calt" # Contextual alternates
            "liga" # Standard ligatures
          ];

          # Cursor settings
          cursor-style = "bar";
          cursor-style-blink = false;

          # Mouse settings
          # Benefit: URL clicking, easier text selection
          mouse-hide-while-typing = true;
          copy-on-select = "clipboard";

          # Scrollback (number of lines to keep)
          # Benefit: Scroll back through long command output
          scrollback-limit = 50000;

          # Window appearance
          window-padding-x = 8;
          window-padding-y = 8;
          window-decoration = false; # Let Niri handle decorations

          # Confirm before closing with running processes
          # Benefit: Prevents accidental termination of builds, ssh sessions
          confirm-close-surface = true;

          # Shell integration (for title, cwd tracking)
          shell-integration = "fish";

          # Performance
          # Benefit: Smoother scrolling and rendering
          gtk-single-instance = true;

          # Keybindings
          keybind = [
            # Quick font size adjustment
            "ctrl+plus=increase_font_size:1"
            "ctrl+minus=decrease_font_size:1"
            "ctrl+zero=reset_font_size"

            # Splits (if using ghostty's built-in splits)
            "ctrl+shift+enter=new_split:right"
            "ctrl+shift+s=new_split:down"

            # Navigate splits
            "ctrl+shift+h=goto_split:left"
            "ctrl+shift+l=goto_split:right"
            "ctrl+shift+k=goto_split:top"
            "ctrl+shift+j=goto_split:bottom"

            # Tabs
            "ctrl+shift+t=new_tab"
            "ctrl+shift+w=close_surface"
            "ctrl+tab=next_tab"
            "ctrl+shift+tab=previous_tab"

            # Scrolling
            "shift+page_up=scroll_page_up"
            "shift+page_down=scroll_page_down"
            "ctrl+shift+home=scroll_to_top"
            "ctrl+shift+end=scroll_to_bottom"
          ];
        };
      };
    };
}
