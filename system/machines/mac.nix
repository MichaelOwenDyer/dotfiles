inputs:
let
  hostPlatform = "x86_64-darwin";
in
inputs.nix-darwin.lib.darwinSystem {

  # Define the system platform
  # system = hostPlatform;

  # Allow the modules listed below to import any input from the flake
  specialArgs = inputs;

  modules = [

    # User modules
    # ../../user/modules
    
    # Machine-specific module closure. This is the closest thing to a configuration.nix in this setup
    (inputs: {

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = hostPlatform;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable the Nix linux-builder for building Linux derivations.
      nix.linux-builder.enable = true;

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;
      
      # Enable sudo Touch ID authentication
      security.pam.enableSudoTouchIdAuth = true;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;
    })
  ];
}