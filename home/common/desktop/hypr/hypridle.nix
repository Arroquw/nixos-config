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
          # https://github.com/hyprwm/hyprlock/issues/59#issuecomment-2023025535
          # Need to take a screenshot with `grim` before idling
          grimCmd = builtins.concatStringsSep " && " (map (m:
            let
              screen = m.name;
              screenShotfile = "/tmp/screenshot-${m.name}.png";
            in "${grim} -o ${screen} ${screenShotfile}") config.monitors);
          #"${grim} -o ${monitors.left} ${screenshotFiles.left} && ${grim} -o ${monitors.right} ${screenshotFiles.right} && ${pkgs.hyprlock}/bin/hyprlock";
        in {
          lock_cmd =
            "${pkgs.procps}/bin/pgrep hyprlock || (${grimCmd} && ${pkgs.hyprlock}/bin/hyprlock)"; # avoid starting multiple hyprlock instances.
          unlock_cmd = "rm -f /tmp/screenshot-*.png";
          before_sleep_cmd = "${loginctl} lock-session"; # lock before suspend.
          after_sleep_cmd =
            "${hyprctl} dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = timeUntilLock - 30;
            on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl s 30%";
            on-resume = "${pkgs.brightnessctl}/bin/brightnessctl s 100%";
          }
          {
            timeout = timeUntilLock;
            on-timeout =
              "${pkgs.procps}/bin/pgrep hyprlock ||  ${loginctl} lock-session"; # lock screen when timeout has passed
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
