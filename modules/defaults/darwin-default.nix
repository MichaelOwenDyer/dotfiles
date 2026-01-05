{
  inputs,
  ...
}:
{
  # Default settings needed for all darwinConfigurations

  flake.modules.darwin.default-settings = {
    imports = [ inputs.self.modules.darwin.overlays ];

    nixpkgs.config.allowUnfree = true;

    # Let Determinate Nix handle the nix installation
    nix.enable = false;
    nix.extraOptions = ''
      warn-dirty = false
    '';

    # Create /etc/zshrc that loads the nix-darwin environment
    programs.zsh.enable = true;

    # Enable sudo Touch ID authentication
    security.pam.services.sudo_local.touchIdAuth = true;

    system.defaults = {
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        ShowPathbar = true;
        FXPreferredViewStyle = "clmv";
        ShowStatusBar = true;
        ShowRemovableMediaOnDesktop = false;
        ShowExternalHardDrivesOnDesktop = false;
        QuitMenuItem = true;
        FXEnableExtensionChangeWarning = false;
        FXDefaultSearchScope = "SCcf";
      };
      dock = {
        autohide = true;
        mru-spaces = false;
      };
      screencapture = {
        type = "png";
        show-thumbnail = false;
        location = "~/Desktop";
        target = "clipboard";
      };
      screensaver.askForPasswordDelay = 10;
    };
  };
}
