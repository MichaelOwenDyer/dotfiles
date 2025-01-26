{ config, lib, pkgs, ... }: 

{
	config.profiles.michael = rec {
		fullName = "Michael Dyer";
		email = "michaelowendyer@gmail.com";
		hashedPassword = "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";

    caffeine.enable = true;

		browser.firefox.enable = true;

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

    development.lang.rust.enable = true;

    development.lang.java = {
      enable = true;
      mainPackage = pkgs.zulu17;
    };

    development.ide.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        dracula-theme.theme-dracula # Dark theme
        bbenoist.nix # Nix lang support
        rust-lang.rust-analyzer # Rust lang support
        vscjava.vscode-java-pack # Java bundle (Red Hat language support, Maven/Gradle, debugger, test runner, IntelliCode)
        tamasfe.even-better-toml # TOML lang support
        github.copilot
        github.copilot-chat
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
        };
      };
    };

    development.ide.jetbrains = {
      plugins = [ "github-copilot" ];
      intellij-idea.enable = true;
      rust-rover.enable = true;
    };

    development.shell.aliases = {
      "rebuild" = "sudo nixos-rebuild switch --flake $1";
    };

    development.shell.zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [
        "sudo"
        "git"
        "git-prompt"
      ];
      #  ++ lib.optionals development.lang.rust.enable [
      # 	"rust"
      # ];
    };
	};
}