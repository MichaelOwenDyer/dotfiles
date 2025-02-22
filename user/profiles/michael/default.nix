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

    development.lang = {
			nix.enable = true;
			rust.enable = true;
			java = {
				enable = true;
				mainPackage = pkgs.zulu17;
			};
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
        "security.workspace.trust.untrustedFiles" = "open";
        "window.zoomLevel" = 2;
        "files.autoSave" = "afterDelay";
        "git.confirmSync" = false;
        "git.autofetch" = true;
        "git.enableSmartCommit" = true;
        "explorer.confirmDragAndDrop" = false;
        "explorer.confirmDelete" = false;
        "explorer.confirmPasteNative" = false;
        "editor.suggest.showSnippets" = false;
        "editor.suggest.showWords" = false;
        "editor.largeFileOptimizations" = false;
        "editor.minimap.enabled" = false;
        "editor.suggestSelection" = "first";
        "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = true;
          "markdown" = true;
          "scminput" = false;
        };
        "github.copilot.editor.enableAutoCompletions" = true;
        "[java]" = {
            "editor.suggest.snippetsPreventQuickSuggestions" = false;
        };
        "redhat.telemetry.enabled" = false;
        "java.autobuild.enabled" = false;
        "java.codeGeneration.hashCodeEquals.useInstanceof" = true;
        "java.codeGeneration.hashCodeEquals.useJava7Objects" = true;
        "java.sources.organizeImports.staticStarThreshold" = 6;
        "java.sources.organizeImports.starThreshold" = 6;
        "nix.formatterPath" = "nixfmt";
        "nix.serverPath" = "nixd";
        "[nix]" = {
          "editor.detectIndentation" = false;
          "editor.insertSpaces" = true;
          "editor.tabSize" = 2;
        };
        "[typst]" = {
            "editor.wordSeparators" = "`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?";
        };
        "[typst-code]" = {
            "editor.wordSeparators" = "`~!@#$%^&*()=+[{]}\\|;:'\",.<>/?";
        };
        "typst-lsp.exportPdf" = "never";
        "files.exclude" = {
            "**/.classpath" = true;
            "**/.project" = true;
            "**/.settings" = true;
            "**/.factorypath" = true;
        };
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
