{ config, lib, pkgs, ... }: let
	
in {
  # Declare configuration options for Slack under options.profiles.<name>.chat.slack
  options.profiles = let inherit (lib) mkOption mkEnableOption; in with lib.types; mkOption {
    type = attrsOf (submodule {
      options.chat.slack.enable = mkEnableOption "Slack";
    });
  };

  # Configure Slack for each user profile
	config.home-manager.users = lib.mapAttrs (username: profile:
		let
			## Choosing the correct package in regards to the window system # TODO: Per-user window manager config
			slackPkg = if (! config.os.wayland) then pkgs.slack else pkgs.slack.overrideAttrs (old: {
				## Wrapping the slack package to enable wayland-specific features
				fixupPhase = ''
					sed -i -e 's/,"WebRTCPipeWireCapturer"/,"LebRTCPipeWireCapturer"/' $out/lib/slack/resources/app.asar

					rm $out/bin/slack
					makeWrapper $out/lib/slack/slack $out/bin/slack \
						--prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
						--suffix PATH : ${lib.makeBinPath [ pkgs.xdg-utils ]} \
						--add-flags "--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations,WebRTCPipeWireCapturer"
				'';
			});
		in {
			# Add Slack to the user's home packages if enabled
			home.packages = lib.optionals profile.chat.slack.enable [ slackPkg ];
		}
	) config.profiles;
}