{ lib, config, pkgs, ... }:
let
  timeUntilLock = 5 * 60;
  timeUntilScreenOff = timeUntilLock + 30;
  timeUntilSuspend = 30 * 60;

  hyprctl = "${lib.getExe' pkgs.hyprland "hyprctl"}";
  loginctl = "${lib.getExe' pkgs.systemd "loginctl"}";
  systemctl = "${lib.getExe' pkgs.systemd "systemctl"}";
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
      systemdTargets = "hyprland-session.target";
    };

    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "${lib.getExe' pkgs.procps "pgrep"} hyprlock || ${
              lib.getExe' pkgs.hyprlock "hyprlock"
            }"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "${loginctl} lock-session"; # lock before suspend.
          after_sleep_cmd =
            "${hyprctl} dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = timeUntilLock - 30;
            on-timeout =
              "${lib.getExe' pkgs.brightnessctl "brightnessctl"} s 30%";
            on-resume =
              "${lib.getExe' pkgs.brightnessctl "brightnessctl"} s 100%";
          }
          {
            timeout = timeUntilLock;
            on-timeout = "${
                lib.getExe' pkgs.procps "pgrep"
              } hyprlock ||  ${loginctl} lock-session"; # lock screen when timeout has passed, don't lock when hyprlock was manually started
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
            on-timeout = "${systemctl} hibernate"; # suspend pc
          }
        ];
      };
    };
  };
}
