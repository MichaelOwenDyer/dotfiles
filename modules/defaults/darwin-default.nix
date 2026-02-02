{
  inputs,
  ...
}:
{
  # Default settings needed for all darwinConfigurations

  flake.modules.darwin.default-settings = {
    imports = [ inputs.self.modules.darwin.overlays ];

    nixpkgs.config.allowUnfree = true;

    nix = {
      # Let Determinate Nix handle the nix installation
      # TODO: These settings are not currently being applied!
      enable = false;
      settings = {
        warn-dirty = false;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
      };
    };

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
        show-thumbnail = false; # Skip the floating thumbnail preview which delays saving
        # Save screenshots to Desktop by default, use control key to save directly to clipboard
        target = "file";
        location = "~/Desktop";
      };
      screensaver.askForPasswordDelay = 10;
    };
  };
}
