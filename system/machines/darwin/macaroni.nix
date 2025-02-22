inputs:
let
  system = "x86_64-darwin";
in
inputs.nix-darwin.lib.darwinSystem {

  # Define the system platform
  inherit system;

  # Allow the modules listed below to import any input from the flake
  specialArgs = inputs;

  modules = [

    # System modules
    ../../modules/darwin
    # User modules
    ../../../user/modules/darwin

    # Machine-specific module closure. This is the closest thing to a configuration.nix in this setup
    (inputs: {

      # Set the host platform
      hostPlatform = system;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = system;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Let Determinate Nix handle the installation
      nix.enable = false;

      # Necessary for using flakes on this system.
#      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

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
    })
  ];
}
