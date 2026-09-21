{
  ...
}:
{
  # Bluetooth with high-quality audio codecs

  flake.modules.nixos.bluetooth =
    { ... }:
    {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            FastConnectable = true;
            Experimental = true;
          };
          Policy = {
            AutoEnable = true;
          };
        };
        input = {
          General = {
            UserspaceHID = true;
          };
        };
      };

      # Use bluetooth devices at login screen
      systemd.services.display-manager = {
        wants = [ "bluetooth.service" ];
        after = [ "bluetooth.service" ];
      };

      # Bluetooth audio config
      services.pipewire.wireplumber.extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "a2dp_sink"
            "a2dp_source"
            "headset_head_unit"
            "headset_audio_gateway"
          ];
        };
      };

      impermanence.persistedDirectories = [ "/var/lib/bluetooth" ];
      impermanence.ephemeralPaths = [ "/etc/bluetooth" ];
    };
}
