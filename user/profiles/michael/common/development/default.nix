{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./vscode.nix
  ];

  config.profiles.michael = {
    development.git = {
      enable = true;
      name = config.profiles.michael.fullName;
      email = config.profiles.michael.email;
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
          ++ lib.optionals config.profiles.michael.development.lang.rust.enable [
            "rust"
          ];
      };
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };
    # TODO: Replace global installs with development shells
    development.lang = {
			nix.enable = true;
			rust.enable = true;
			java = {
				enable = lib.mkDefault true;
				mainPackage = pkgs.zulu17;
			};
		};
    programs.gnome-shell = {
      enable = true;
      extensions = with pkgs.gnomeExtensions; [
        { package = coverflow-alt-tab; }
      ];
    };
    packages = with pkgs; [
      gnome-tweaks
    ];
  };
}