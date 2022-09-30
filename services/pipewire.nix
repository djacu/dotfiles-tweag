{ config, pkgs, ... }: {
  # rtkit is optional but recommended
  security.rtkit.enable = true;

  services.pipewire.enable = true;
  services.pipewire.pulse.enable = true;
  # services.pipewire.audio.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
}
