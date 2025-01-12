{ config, settings, lib, pkgs, ... }: let
	vscodePkg = (pkgs.vscode-with-extensions.override {
		vscodeExtensions = with pkgs.vscode-extensions; [
			dracula-theme.theme-dracula # Dark theme
			bbenoist.nix # Nix lang support
			rust-lang.rust-analyzer # Rust lang support
			vscjava.vscode-java-pack # Java bundle (Red Hat language support, Maven/Gradle, debugger, test runner, IntelliCode)
			tamasfe.even-better-toml # TOML lang support
			github.copilot
			github.copilot-chat
		];
	});
in {
	
  config.home-manager.users.${config.user} = {
		programs.vscode = {
			enable = true;
			package = vscodePkg;
			
			userSettings = {
				window.titleBarStyle = "custom"; 

				## No auto-sync
				git.confirmSync = false;
				
				## Auto save
				files.autoSave = "onFocusChange";

				## No tabs
				workbench.editor.showTabs = "none";

				## Indentation
			#   "editor.tabSize" =  2;
			#   "editor.detectIndentation" = false;

				## Font
			#   "editor.fontFamily" = "'${config.os.fonts.mono.regular}', 'monospace', monospace";
			#   "editor.fontSize" = config.os.fonts.size + 2;
			#   "editor.fontLigatures" = true;

				# typscript
				#"typescript.tsserver.log" = "verbose";
			#   "typescript.tsdk" = "${pkgs.nodePackages.typescript}/lib/node_modules/typescript/lib";
			};

			keybindings = [
			#   { key = "ctrl+shift+alt+p"; command = "eslint.executeAutofix"; }
				{
					key = "ctrl+alt+o";
					command = "editor.action.organizeImports";
					when = "textInputFocus && !editorReadonly && supportedCodeAction =~ /(\\s|^)source\\.organizeImports\\b/";
				}
			];
		};
	};
}

