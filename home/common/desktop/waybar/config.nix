{ config, pkgs, ... }:
let
  homeDir = config.home.homeDirectory;
  pamixer = pkgs.pamixer + "/bin/pamixer";
in {
  mainBar = {
    layer = "top";
    position = "top";
    exclusive = true;
    passthrough = false;
    fixed-center = true;
    gtk-layer-shell = true;
    height = 34;
    modules-left = [ "custom/logo" "hyprland/workspaces" "tray" ];

    modules-center = [ ];

    modules-right = [
      "pulseaudio#microphone"
      "pulseaudio"
      "network"
      "clock#date"
      "clock"
      "custom/power"
    ];

    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
      active-only = false;
      all-outputs = false;
      "format-icons" = {
        "1" = "一";
        "2" = "二";
        "3" = "三";
        "4" = "四";
        "5" = "五";
        "6" = "六";
        "7" = "七";
        "8" = "八";
        "9" = "九";
        "10" = "十";
      };
      "persistent-workspaces" = { "*" = 5; };
    };

    "custom/logo" = {
      tooltip = false;
      format = " ";
    };

    # "custom/swallow" = {
    #   tooltip = false;
    #   on-click = let
    #     hyprctl = config.wayland.windowManager.hyprland.package
    #       + "/bin/hyprctl";
    #     notify-send = pkgs.libnotify + "/bin/notify-send";
    #     rg = pkgs.ripgrep + "/bin/rg";
    #   in pkgs.writeShellScript "waybar-swallow" ''
    #     #!/bin/sh
    #     if ${hyprctl} getoption misc:enable_swallow | ${rg}/bin/rg -q "int: 1"; then
    #     	${hyprctl} keyword misc:enable_swallow false >/dev/null &&
    #     		${notify-send} "Hyprland" "Turned off swallowing"
    #     else
    #     	${hyprctl} keyword misc:enable_swallow true >/dev/null &&
    #     		${notify-send} "Hyprland" "Turned on swallowing"
    #     fi
    #   '';
    #   format = "󰊰";
    # };

    "custom/power" = {
      tooltip = false;
      on-click = "${homeDir}/.config/rofi/scripts/power.sh";
      format = "󰤆";
    };

    tray = { spacing = 10; };

    clock = {
      tooltip = false;
      format = "󱑎 {:%H:%M}";
    };

    "clock#date" = {
      format = "󰃶 {:%a %d %b}";
      tooltip-format = ''
        <big>{:%Y %B}</big>
        <tt><small>{calendar}</small></tt>'';
    };

    # backlight = {
    #   tooltip = false;
    #   format = "{icon} {percent}%";
    #   format-icons = [ "󰋙" "󰫃" "󰫄" "󰫅" "󰫆" "󰫇" "󰫈" ];
    #   on-scroll-up = "${brightnessctl} s 1%-";
    #   on-scroll-down = "${brightnessctl} s +1%";
    # };

    # battery = {
    #   states = {
    #     warning = 30;
    #     critical = 15;
    #   };
    #   format = "{icon} {capacity}%";
    #   tooltip-format = "{timeTo}, {capacity}%";
    #   format-charging = "󰂄 {capacity}%";
    #   format-plugged = "󰚥 {capacity}%";
    #   format-alt = "{time} {icon}";
    #   format-icons = [ "󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
    # };

    network = {
      format-wifi = "󰖩 {essid}";
      format-ethernet = "󰈀 {ipaddr}/{cidr}";
      format-alt = "󱛇";
      format-disconnected = "󰖪";
      tooltip-format = ''
        󰅃 {bandwidthUpBytes} 󰅀 {bandwidthDownBytes}
        {ipaddr}/{ifname} via {gwaddr} ({signalStrength}%)'';
    };

    pulseaudio = {
      tooltip = false;
      format = "{icon} {volume}%";
      format-muted = "󰖁";
      format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
      tooltip-format = "{desc}, {volume}%";
      on-click = "${pamixer} -t";
      on-scroll-up = "${pamixer} -d 1";
      on-scroll-down = "${pamixer} -i 1";
    };

    "pulseaudio#microphone" = {
      tooltip = false;
      format = "{format_source}";
      format-source = "󰍬 {volume}%";
      format-source-muted = "󰍭";
      on-click = "${pamixer} --default-source -t";
      on-scroll-up = "${pamixer} --default-source -d 1";
      on-scroll-down = "${pamixer} --default-source -i 1";
    };
  };
}
