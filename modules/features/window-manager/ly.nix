{
  ...
}:
{
  # Minimalist ly login manager

  flake.modules.nixos.ly =
    { pkgs, ... }:
    {
      services.displayManager.ly = {
        enable = true;
        # Use master nixpkgs version to work around build failure in unstable
        # (ln: failed to create symbolic link '/p': Permission denied)
        package = pkgs.master.ly;
      };

      # Impermanence: persist last selected user/session
      impermanence.persistedFiles = [ "/etc/ly/save.txt" ];
      impermanence.ephemeralPaths = [ "/etc/ly/config.ini" ];
    };
}
