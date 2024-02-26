{ pkgs, ... }:
let lockTime = 10 * 60;
in {
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    timeouts = [
      {
        timeout = lockTime;
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        timeout = lockTime;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };
}
