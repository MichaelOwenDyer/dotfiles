{ settings, config, lib, pkgs, ... }: let
	inherit (lib) mkDefault;
in {
	config.profiles.michael = rec {
		fullName = mkDefault "Michael Dyer";
		email = mkDefault "michaelowendyer@gmail.com";
		hashedPassword = mkDefault "$y$j9T$pSkVWxgO/9dyqt8MMHzaM0$RO5g8OOpFb4pdgMuDIVraPvsLMSvMTU2/y8JQWfmrs1";

		browser.firefox.enable = true;

		development = rec {
			git = {
				enable = mkDefault true;
				name = fullName;
				email = email;
				extraConfig = {
					init = {
						defaultBranch = mkDefault "main";
					};
					pull = {
						rebase = mkDefault true;
					};
					url = mkDefault {
						"https://github.com" = {
							insteadOf = [
								"gh:"
								"github:"
							];
						};
					};
				};
			};
			lang = {
				rust.enable = mkDefault true;
				java.enable = mkDefault true;
				java.mainVersion = mkDefault "17";
			};
			ide = {
				vscode.enable = mkDefault true;
				jetbrains = {
					default-plugins = mkDefault [ "github-copilot" ];
					# intellij-idea.enable = mkDefault true;
					# rust-rover.enable = mkDefault true;
				};
			};
			shell.zsh = {
				enable = mkDefault true;
				oh-my-zsh.enable = mkDefault true;
				oh-my-zsh.plugins = [
					"sudo"
					"git"
					"git-prompt"
				];
				#  ++ lib.optionals settings.profiles.michael.development.lang.rust.enable [ TODO: Figure out how to reference settings in options
				# 	"rust"
				# ];
			};
		};
	};
}