{
  inputs,
  ...
}:
{
  # Assign user michael to host rustbucket with host-specific configuration

  flake.modules.nixos.michael-rustbucket =
    { ... }:
    {
      imports = [ inputs.self.modules.nixos.michael ];

      home-manager.users.michael = {
        imports = [ inputs.self.modules.homeManager.michael-rustbucket ];
      };
    };

  # Host-specific home-manager configuration for michael on rustbucket
  flake.modules.homeManager.michael-rustbucket =
    { ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        michael
        niri
        niri-outputs-rustbucket
        dank-material-shell
        idle
        zen-browser
        development
        gaming
        openclaw
        discord
      ];

      # Enable yazi impermanence plugin since this host uses impermanence
      programs.yazi.impermanence.enable = true;

      services.idle = {
        displayTimeout = 300;
        lockTimeout = 600;
      };

      openclaw.telegram.allowedChatIds = [ inputs.self.lib.openclaw.telegramUserIds.michael ];

      home.stateVersion = "24.11";
    };
}
