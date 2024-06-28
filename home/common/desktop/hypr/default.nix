{ lib, self, config, pkgs, inputs, ... }: {
  imports = [ ./hypridle.nix ./hyprlock.nix ];
  home.packages = with pkgs; [
    swww
    inputs.hyprwm-contrib.packages.${pkgs.system}.hyprprop
    wlroots
    grim
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = import ./hyprland.nix { inherit config self pkgs lib; };
  };

  # xdg.configFile."hypr/hyprlock.conf" = {
  #   enable = true;
  #   text = ''
  #     background {
  #       monitor =
  #       path = /home/justin/Desktop/wallpapers/lockscreen/serey-morm-Z9G2Cm3n080-unsplash.png
  #       contrast = 0.8916
  #       brightness = 0.8172
  #       vibrancy = 0.1696
  #       vibrancy_darkness = 0.0
  #     }
  #     general {
  #       no_fade_in = false
  #       grace = 5
  #     }
  #     input-field {
  #       monitor =
  #       size = 250, 60
  #       outline_thickness = 2
  #       dots_size = 0.2
  #       dots_spacing = 0.2
  #       dots_center = true
  #       outer_color = rgb(38,148,46) #26942e
  #       inner_color = rgb(36,58,39) #243a27
  #       font_color = rgb(38,148,46) #26942e
  #       fade_on_empty = false
  #       placeholder_text = <i><span foreground="##cdd6f4">Input Password...</span></i>
  #       hide_input = false
  #       position = 0, -120
  #       halign = center
  #       valign = center
  #     }
  #     label {
  #       monitor =
  #       text = cmd[update:1000] date +"%-H:%M"
  #       color = rgb(192,240,240) #C0F0F0
  #       font_size = 120
  #       position = 0, -300
  #       halign = center
  #       valign = top
  #     }
  #     label {
  #       monitor =
  #       text = cmd[] echo hello, $USER | sed -r 's/\w+/\u&/g'
  #       color = rgb(192,240,240) #C0F0F0
  #       font_size = 25
  #       position = 0, -40
  #       halign = center
  #       valign = center
  #     }
  #   '';
  # };
  #
  # xdg.configFile."hypr/hypridle.conf" = {
  #   enable = true;
  #   text = ''
  #     general {
  #       lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
  #     }
  #     listener {
  #       timeout = 600                           # 10min
  #       on-timeout = loginctl lock-session      # command to run when timeout has passed
  #     }
  #     listener {
  #       timeout = 630                           # 10.5min
  #       on-timeout = hyprctl dispatch dpms off  # command to run when timeout has passed
  #       on-resume = hyprctl dispatch dpms on    # command to run when activity is detected after timeout has fired.
  #     }
  #   '';
  # };
}
