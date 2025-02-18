{
  lib,
  pkgs,
	config,
	nixpkgs-stable,
  ...
}:

{
  config.profiles.michael = rec {
    fullName = "Michael Dyer";
    email = "michaelowendyer@gmail.com";
    hashedPassword = "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "networkmanager"
    ];

    # wm = "gnome";

    caffeine.enable = true;

    browser.firefox = {
			enable = true;
			extensions = with pkgs.nur.repos.rycee.firefox-addons; [
				ublock-origin
			];
		};

    development.git = {
      enable = true;
      name = fullName;
      email = email;
      config = {
        init = {
          defaultBranch = "main";
        };
        pull = {
          rebase = true;
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

    development.lang.nix.enable = true;

    development.lang.rust.enable = true;

    development.lang.java = {
      enable = true;
      mainPackage = pkgs.zulu17;
    };

    development.ide.vscode = {
      enable = true;
      # pkgs.vscode-extensions: https://github.com/nix-community/nix-vscode-extensions
      extensions =
        with pkgs.vscode-extensions;
        [
          k--kato.intellij-idea-keybindings # IntelliJ keybindings
          dracula-theme.theme-dracula # Dark theme
          github.copilot # Copilot AI
          github.copilot-chat # Copilot chat
          eamodio.gitlens # GitLens
        ]
        ++ lib.optionals development.lang.nix.enable [
          jnoortheen.nix-ide
        ]
        ++ lib.optionals development.lang.rust.enable [
          tamasfe.even-better-toml # TOML lang support
					# TODO: Bring back to unstable
          nixpkgs-stable.legacyPackages.${config.hostPlatform}.vscode-extensions.rust-lang.rust-analyzer # Rust lang support
        ]
        ++ lib.optionals development.lang.java.enable [
          vscjava.vscode-java-pack # Java bundle (Red Hat language support, Maven/Gradle, debugger, test runner, IntelliCode)
        ];
      userSettings = {
        "files.autoSave" = "afterDelay";
        "git.confirmSync" = false;
        "git.autofetch" = true;
        "git.enableSmartCommit" = true;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "github.copilot.enable" = {
          "*" = true;
        };
        "[nix]" = {
          "editor.tabSize" = 2;
          "editor.detectIndentation" = false;
          "editor.insertSpaces" = false;
        };
        "nix.formatterPath" = "nixfmt";
        "nix.serverPath" = "nixd";
      };
    };

    development.shell.zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins =
          [
            "sudo"
            "git"
            "git-prompt"
          ]
          ++ lib.optionals development.lang.rust.enable [
            "rust"
          ];
      };
    };
  };
}
