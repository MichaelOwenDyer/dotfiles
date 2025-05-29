{
  config,
  lib,
  pkgs,
  ...
}:

{
  config.profiles.michael = {
    development.ide.vscode = {
      enable = true;
      # pkgs.vscode-extensions: https://github.com/nix-community/nix-vscode-extensions
      extensions =
        let
          lang = config.profiles.michael.development.lang;
        in
        with pkgs.vscode-extensions;
        [
          k--kato.intellij-idea-keybindings
          dracula-theme.theme-dracula
          github.copilot
          github.copilot-chat
          eamodio.gitlens
          ocamllabs.ocaml-platform
          tamasfe.even-better-toml
          vscjava.vscode-java-pack # Java bundle (Red Hat language support, Maven/Gradle, debugger, test runner, IntelliCode)
					# TODO: Bring back to unstable
          pkgs.stable.vscode-extensions.rust-lang.rust-analyzer
          jnoortheen.nix-ide
          mkhl.direnv 
          myriad-dreamin.tinymist # Typst
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
        "gitlens.hovers.enabled" = false;
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
  };
}