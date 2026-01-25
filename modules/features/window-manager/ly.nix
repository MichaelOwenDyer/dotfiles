{
  ...
}:
{
  # Minimalist ly login manager

  flake.modules.nixos.ly =
    { config, lib, ... }:
    {
      services.displayManager.ly.enable = true;

      # Impermanence: persist last selected user/session
      impermanence = lib.mkIf (config ? impermanence) {
        persistedDirectories = [ "/etc/ly" ];
      };
    };
}