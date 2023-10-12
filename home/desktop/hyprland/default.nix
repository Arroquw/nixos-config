_: {
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix {
      kb_variant = "";
      kb_options = "";
      monitor_config = "";
    };
  };
}
