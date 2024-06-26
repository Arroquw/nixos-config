{ config, pkgs, ... }:
let
  timeUntilLock = 5 * 60;
  timeUntilScreenOff = timeUntilLock + 30;
  timeUntilSuspend = 30 * 60;

  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  loginctl = "${pkgs.systemd}/bin/loginctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
in {
  services = {
    wlsunset = {
      enable = true;
      latitude = "51.5";
      longitude = "5.4";
      temperature.night = 3500;
    };

    cliphist = {
      enable = true;
      systemdTarget = "hyprland-session.target";
    };

    hypridle = {
      enable = true;
      settings = {
        general = let
          grim = "${pkgs.grim}/bin/grim";
          screenshotFiles = {
            left = "/tmp/lockscreen-left.png";
            right = "/tmp/lockscreen-right.png";
          };

          monitors = builtins.listToAttrs (map (m: {
            name =
              if m.x == 0 || !builtins.hasAttr "x" m then "left" else "right";
            value = if m.name == null then "DP-1" else toString (m.name);
          }) config.monitors);
          # https://github.com/hyprwm/hyprlock/issues/59#issuecomment-2023025535
          # Need to take a screenshot with `grim` before idling
          hyprlockCmd =
            "${grim} -o ${monitors.left} ${screenshotFiles.left} && ${grim} -o ${monitors.right} ${screenshotFiles.right} && ${pkgs.hyprlock}/bin/hyprlock";
        in {
          lock_cmd =
            "pidof hyprlock || ${hyprlockCmd}"; # avoid starting multiple hyprlock instances.
          unlock_cmd =
            "rm -rf ${screenshotFiles.left} ${screenshotFiles.right}";
          before_sleep_cmd = "${loginctl} lock-session"; # lock before suspend.
          after_sleep_cmd =
            "${hyprctl} dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          # TODO: Add screen dimming
          {
            timeout = timeUntilLock;
            on-timeout =
              "${loginctl} lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = timeUntilScreenOff;
            on-timeout =
              "${hyprctl} dispatch dpms off"; # screen off when timeout has passed
            on-resume =
              "${hyprctl} dispatch dpms on"; # screen on when activity is detected after timeout has fired.
          }

          {
            timeout = timeUntilSuspend;
            on-timeout = "${systemctl} suspend"; # suspend pc
          }
        ];
      };
    };
  };
}
