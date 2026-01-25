{
  ...
}:
{
  # Bluetooth with high-quality audio codecs

  flake.modules.nixos.bluetooth =
    { config, lib, ... }:
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

      # Impermanence: explicitly persist paired device state
      impermanence = lib.mkIf (config ? impermanence) {
        persistedDirectories = [ "/var/lib/bluetooth" ];
      };
    };
}
