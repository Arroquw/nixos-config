{ pkgs, user, ... }: {
  # Enable sound with pipewire.
  #  sound.enable = true;
  security.rtkit.enable = true;
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      systemWide = true;

      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
  users.users.${user}.packages = with pkgs; [
    alsa-utils
    pulseaudio
    pavucontrol
  ];
}
