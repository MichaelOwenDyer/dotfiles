{
  wayland
}:

{
  lib,
  pkgs,
  ...
}:

let
  slack = if !wayland then
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
{
  home.packages = [ slack ];
}