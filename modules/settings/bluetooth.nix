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
      };

      # WirePlumber configuration for Bluetooth audio
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
      impermanence.ephemeralPaths = [
        "/etc/bluetooth"
        "/etc/main.conf" # Bluetooth main config
      ];
    };
}
