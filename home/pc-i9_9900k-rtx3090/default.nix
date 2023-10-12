{ ... }: {
  imports = [ ../default.nix ];

  programs = {
    git = {
      userName = "arroquw";
      userEmail = "justinvanson@outlook.com";
    };
  };
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ../desktop/hyprland/config.nix {
      kb_variant = "";
      kb_options = "";
      monitor_config = ''
        monitor=DP-1-1,2560x1440@60.0,2560x1080,1;
        monitor=DP-1-2,2560x1440@60.0,0x1080,1;
      '';
    };
  };

}
