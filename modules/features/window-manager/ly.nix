{
  ...
}:
{
  # Minimalist ly login manager

  flake.modules.nixos.ly =
    { ... }:
    {
      services.displayManager.ly.enable = true;

      # Impermanence: persist last selected user/session
      impermanence.persistedDirectories = [ "/etc/ly" ];
    };
}