{
  hostname,
  users,
}:

{
  lib,
  config,
  ...
}:

{
  # Let Determinate Nix handle the nix installation
  nix.enable = false;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  networking.hostName = hostname;

  home-manager.users = lib.mapAttrs (username: home: import home inputs) users;

  users.users =
    lib.mapAttrs
    (
      username: home:
      {
        description = home.systemIntegration.description;
        home = /Users/${home.systemIntegration.username};
        createHome = false;
      }
    )
    config.home-manager.users;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Enable sudo Touch ID authentication
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    finder = {
      # Always show extensions
      AppleShowAllExtensions = true;
      # Always show all files
      AppleShowAllFiles = true;
      # Always show the file path
      ShowPathbar = true;
      # Default Finder folder view is the columns view
      FXPreferredViewStyle = "clmv";
      # Display file size stats at bottom of window
      ShowStatusBar = true;
      # Don't show things on Desktop
      ShowRemovableMediaOnDesktop = false;
      ShowExternalHardDrivesOnDesktop = false;
      # Allow quitting Finder
      QuitMenuItem = true;
      # Don't warn about changing file extensions
      FXEnableExtensionChangeWarning = false;
      # Use current folder as search scope
      FXDefaultSearchScope = "SCcf";
    };
    dock = {
      # Hide dock automatically
      autohide = true;
      # Don’t rearrange spaces based on the most recent use
      mru-spaces = false;
    };
    screencapture = {
      # Save as png
      type = "png";
      # Don't show thumbnail before saving
      show-thumbnail = false;
      # Save to Desktop
      location = "~/Desktop";
      # Copy to clipboard automatically
      target = "clipboard";
    };
    # Give 10 second grace period on screensaver before asking for password
    screensaver.askForPasswordDelay = 10;
  };
}
