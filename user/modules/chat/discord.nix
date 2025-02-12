{
  config,
  lib,
  pkgs,
  ...
}:
let

in
{
  # Declare configuration options for Discord under options.profiles.<name>.chat.discord
  options.profiles =
    with lib.types;
    lib.mkOption {
      type = attrsOf (submodule {
        options.chat.discord = {
          enable = lib.mkEnableOption "Discord";
        };
      });
    };

  config = {
    home-manager.users = lib.mapAttrs (
			username: profile:
      let
        cfg = profile.chat.discord;
        ## Choosing the correct package in regards to the window system # TODO: Per-user window manager config
        discord =
          if (!config.os.wayland) then
            pkgs.discord
          else
            pkgs.discord.overrideAttrs (old: {
              # Wrapping the discord package to enable wayland-specific features
              installPhase =
                old.installPhase
                + ''
									# Remove the binaries that were just installed
									rm $out/bin/Discord
									rm $out/bin/discord

									# Create wrappers with wayland flags
									makeWrapper $out/opt/Discord/Discord $out/bin/Discord \
										--prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
										--prefix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
										--add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
									
									makeWrapper $out/opt/Discord/Discord $out/bin/discord \
										--prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
										--prefix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
										--add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
									'';
            });
      in
      lib.mkIf cfg.enable {
        # Add Discord to the user's home packages
        home.packages = [ discord ];
      }
    ) config.profiles;
  };
}
