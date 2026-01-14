{
  inputs,
  ...
}:
{
  # Fish shell configuration

  flake.modules.homeManager.fish-shell =
    { pkgs, ... }:
    {
      home.shell.enableFishIntegration = true;
      home.packages = [ pkgs.grc ];

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting # Disable greeting
        '';
        plugins = with pkgs.fishPlugins; [
          {
            name = "grc";
            src = grc.src;
          }
          {
            name = "sponge";
            src = sponge.src;
          }
          {
            name = "sudope";
            src = plugin-sudope.src;
          }
          {
            name = "git";
            src = plugin-git.src;
          }
          {
            name = "eclm";
            src = pkgs.fetchFromGitHub {
              owner = "oh-my-fish";
              repo = "theme-eclm";
              rev = "185c84a41947142d75c68da9bc6c59bcd32757e7";
              sha256 = "OBku4wwMROu3HQXkaM26qhL0SIEtz8ShypuLcpbxp78=";
            };
          }
        ];
      };
    };

  # NixOS needs fish enabled for users to use it as shell
  flake.modules.nixos.fish-shell = {
    programs.fish.enable = true;
  };

  flake.modules.darwin.fish-shell = {
    programs.fish.enable = true;
  };
}
