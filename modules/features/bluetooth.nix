{
  ...
}:
{
  flake.modules.nixos.bluetooth =
    { ... }:
    {
      hardware.bluetooth.enable = true; # enables support for Bluetooth
      hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

      # Optional: if using PipeWire for audio
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
    };
}
