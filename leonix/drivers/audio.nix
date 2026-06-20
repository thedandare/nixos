{ ... }:
{
  # 🔊 Sound blasting.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true; # If you want to use JACK applications
  };
  security.rtkit.enable = true; # rtkit (optional, recommended) allows Pipewire to use the realtime scheduler for increased performance.
}
