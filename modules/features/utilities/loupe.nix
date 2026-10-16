{
  ...
}:
{
  # Loupe - GNOME image viewer (GTK4/Rust)

  flake.modules.homeManager.loupe =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.loupe ];

      # Set as default image viewer
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "image/jpeg" = "org.gnome.Loupe.desktop";
          "image/png" = "org.gnome.Loupe.desktop";
          "image/gif" = "org.gnome.Loupe.desktop";
          "image/webp" = "org.gnome.Loupe.desktop";
          "image/svg+xml" = "org.gnome.Loupe.desktop";
          "image/bmp" = "org.gnome.Loupe.desktop";
          "image/tiff" = "org.gnome.Loupe.desktop";
          "image/avif" = "org.gnome.Loupe.desktop";
          "image/heic" = "org.gnome.Loupe.desktop";
        };
      };
    };
}
