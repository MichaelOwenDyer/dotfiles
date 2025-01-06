{ config, pkgs, userSettings, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.username;
  home.homeDirectory = "/home/${userSettings.username}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Allow unfree packages
  nixpkgs.config = { allowUnfree = true; };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    alacritty
    rustup
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        dracula-theme.theme-dracula # Dark theme
        bbenoist.nix # Nix lang support
        rust-lang.rust-analyzer # Rust lang support
        vscjava.vscode-java-pack # Java bundle (Red Hat language support, Maven/Gradle, debugger, test runner, IntelliCode)
        tamasfe.even-better-toml # TOML lang support
        github.copilot
        github.copilot-chat
      ];
    })
    # (jetbrains.plugins.addPlugins jetbrains.idea-ultimate [ "github-copilot" ])
    # (jetbrains.plugins.addPlugins jetbrains.rust-rover [ "github-copilot" ])

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      url = {
        "https://github.com" = {
          insteadOf = [
            "gh:"
            "github:"
          ];
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      # See https://github.com/ohmyzsh/ohmyzsh/wiki/plugins for a list of plugins
      plugins = [
        "sudo"
        "git"
        "git-prompt"
        "rust"
      ];
    };
  };

  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" "de" ];
    profiles."${userSettings.username}" = {
      id = 0;
      # TODO: Need to install Nix User Repository (https://github.com/nix-community/NUR) for this to work
      # TODO: Configure ublock https://medium.com/@yaduvanshiharsh15/reclaim-your-time-how-to-stop-youtube-shorts-with-ublock-origin-ed74af6560b1
      # extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      #   ublock-origin
      # ];
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/michael/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
}
