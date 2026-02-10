{
  ...
}:
{
  # Discord via Vesktop (Discord client with Vencord built-in)
  # Vesktop has native Wayland support and doesn't require XWayland

  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vesktop ];
    };
}
