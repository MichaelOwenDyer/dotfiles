{
  config,
  lib,
  util,
  pkgs,
  ...
}:

{
  # Declare configuration options for Slack under options.profiles.<name>.chat.slack
  options = util.mkProfileOption lib {
    chat.slack.enable = lib.mkEnableOption "Slack";
  };

  # Configure Slack for each user profile
  config = {
    home-manager.users = lib.mapAttrs (
      username: profile:
      let
        cfg = profile.chat.slack;
        # Choose the correct Slack package for the window system
        slack =
          if (!profile.wayland.enable) then
            pkgs.slack
          else
            pkgs.slack.overrideAttrs (old: {
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
      in
      lib.mkIf cfg.enable {
        # Add Slack to the user's home packages if enabled
        home.packages = [ slack ];
      }
    ) config.profiles;
  };
}
