{ config, lib, pkgs, ... }: let
	
in {
	config.home-manager.users = lib.mapAttrs (username: profile:
		let
			## Choosing the correct package in regards to the window system # TODO: Per-user window manager config
			discordPkg = if (! config.os.wayland) then pkgs.discord else pkgs.discord.overrideAttrs (old: {
				# Wrapping the discord package to enable wayland-specific features
				installPhase = old.installPhase + ''
					# Remove the binaries that were just installed
					rm $out/bin/Discord
					rm $out/bin/discord

					# Create wrappers with wayland flags
					makeWrapper $out/opt/Discord/Discord $out/bin/Discord \
						--prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
						--prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
						--add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
					
					makeWrapper $out/opt/Discord/Discord $out/bin/discord \
						--prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
						--prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
						--add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
				'';
			});
		in {
			# Add Discord to the user's home packages
			home.packages = lib.optionals profile.chat.discord.enable [ discordPkg ];
		}
	) config.profiles;
}
