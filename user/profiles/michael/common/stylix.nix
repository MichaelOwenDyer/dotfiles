_:

{
  config.profiles.michael = {
    stylix = {
      enable = true;

      # TODO: Figure out where these need to go to get rid of warnings
      # targets = {
      #   vscode.profileNames = [ "michael" ];
      #   firefox.profileNames = [ "michael" ];
      #   qt.platform = "qctc";
      #   qt.platformTheme.name = "adwaita";
      # };

      base16Scheme = {
        slug = "google-dark-catppuccin-macchiato";
        name = "Google Dark Catppuccin Macchiato";
        author = "Michael Dyer";
        variant = "dark";
        palette = {
          base00 = "1d1f21"; #1d1f21
          base01 = "282a2e"; #282a2e
          base02 = "373b41"; #373b41
          base03 = "969896"; #969896
          base04 = "b4b7b4"; #b4b7b4
          base05 = "c5c8c6"; #c5c8c6
          base06 = "e0e0e0"; #e0e0e0
          base07 = "ffffff"; #ffffff
          base08 = "ed8796"; #ed8796
          base09 = "f5a97f"; #f5a97f
          base0A = "eed49f"; #eed49f
          base0B = "a6da95"; #a6da95
          base0C = "8bd5ca"; #8bd5ca
          base0D = "8aadf4"; #8aadf4
          base0E = "c6a0f6"; #c6a0f6
          base0F = "f0c6c6"; #f0c6c6
        };
      };

      opacity = {
        terminal = 0.5;
        popups = 0.5;
      };
    };
  };
}