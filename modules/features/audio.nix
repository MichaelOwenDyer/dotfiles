{
  ...
}:
{
  # PipeWire audio with PulseAudio and ALSA compatibility

  flake.modules.nixos.audio = {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true; # Realtime scheduling for audio

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # jack.enable = true; # Uncomment for JACK applications
    };

    impermanence.ephemeralPaths = [
      "/etc/alsa"
      "/etc/pipewire"
    ];
  };
}
