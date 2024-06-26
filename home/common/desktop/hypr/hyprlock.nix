{ config, pkgs, ... }:
let
  timeUntilLock = 5 * 60;
  timeUntilScreenOff = timeUntilLock + 30;
  timeUntilSuspend = 30 * 60;

  monitors = builtins.listToAttrs (map (m: {
    name = if (m.x == 0) || !builtins.hasAttr "x" m then "left" else "right";
    value = toString (m.name);
  }) config.monitors);
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

      background = [
        {
          monitor = monitors.left;
          path = "/tmp/lockscreen-left.png";
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
          blur = "yes";
          blur_passes = 7;
          blur_size = 10;
          #color = "rgb(0,0,0)";
          opacity = 0.5;
        }
        {
          monitor = monitors.right;
          path = "/tmp/lockscreen-right.png";
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
          blur = "yes";
          blur_passes = 10;
          blur_size = 7;
          #color = "rgb(0,0,0)";
          opacity = 0.5;
        }
        {
          monitor = "";
          color = "rgb(0,0,0)";
        }
      ];

      label = [
        {
          monitor = "";
          size = "200, 50";
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

