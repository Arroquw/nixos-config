{ config, osConfig, ... }:
let
  timeUntilLock = 5 * 60;
  timeUntilScreenOff = timeUntilLock + 30;

in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = timeUntilLock - timeUntilScreenOff;
        ignore_empty_input = true;
        no_fade_out = true; # bit buggy, so disable it
        no_fade_in = false;
      };

      background = let
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
        blur_passes = 3;
        blur_size = 8;
        color = "rgb(64,64,64)"; # #404040
        # No longer need this if..else block once https://github.com/hyprwm/hyprlock/issues/59 is fixed (replace with else clause)
      in if osConfig.arroquw.nvidia.enable then
        map (m:
          let
            monitor = m.name;
            path = "/tmp/screenshot-${monitor}.png";
          in {
            inherit monitor;
            inherit path;
            inherit contrast;
            inherit brightness;
            inherit vibrancy;
            inherit vibrancy_darkness;
            inherit blur_passes;
            inherit blur_size;
            inherit color;
          }) (builtins.filter (f: f.enabled) config.monitors)
      else [{
        monitor = "";
        path = "screenshot";
        inherit contrast;
        inherit brightness;
        inherit vibrancy;
        inherit vibrancy_darkness;
        inherit blur_passes;
        inherit blur_size;
        inherit color;
      }];
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] date +%T";
          color = "rgb(192,240,240)"; # #C0F0F0
          position = "0, -300";
          halign = "center";
          valign = "top";
          font_size = 120;
        }
        {
          monitor = "";
          text = "cmd[] echo Hello, $USER | sed -r 's/w+/u&/g'";
          color = "rgb(192,240,240)"; # #C0F0F0
          font_size = 25;
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [{
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        position = "0, -120";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(91, 96, 120)";
        outer_color = "rgb(24, 25, 38)";
        placeholder_text =
          ''<span foreground="##cad3f5">Input password...</span>'';
        shadow_passes = 2;
      }];
    };
  };
}

