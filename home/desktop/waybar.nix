{ self, config, lib, pkgs, ... }:
let
  # Dependencies
  cut = "${pkgs.coreutils}/bin/cut";
  grep = "${pkgs.gnugrep}/bin/grep";
  tail = "${pkgs.coreutils}/bin/tail";
  wc = "${pkgs.coreutils}/bin/wc";
  xargs = "${pkgs.findutils}/bin/xargs";

  jq = "${pkgs.jq}/bin/jq";
  gamemoded = "${pkgs.gamemode}/bin/gamemoded";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  journalctl = "${pkgs.systemd}/bin/journalctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  playerctld = "${pkgs.playerctl}/bin/playerctld";
  pavucontrol = "${pkgs.pavucontrol}/bin/pavucontrol";
  wallpaper-script =
    "${self.packages.${pkgs.system}.changewallpaper}/bin/changewallpaper";
  powermenu-script =
    "${self.packages.${pkgs.system}.rofi-power-menu}/bin/rofi-power-menu";
  network-manager-script = "${
      self.packages.${pkgs.system}.rofi-network-manager
    }/bin/rofi-network-manager";
  weather-py =
    "${self.packages.${pkgs.system}.waybar-weather}/bin/waybar-weather";
  # Function to simplify making waybar outputs
  jsonOutput = name:
    { pre ? "", text ? "", tooltip ? "", alt ? "", class ? "", percentage ? ""
    }:
    "${
      pkgs.writeShellScriptBin "waybar-${name}" ''
        set -euo pipefail
        ${pre}
        ${jq} -cn \
          --arg text "${text}" \
          --arg tooltip "${tooltip}" \
          --arg alt "${alt}" \
          --arg class "${class}" \
          --arg percentage "${percentage}" \
          '{text:$text,tooltip:$tooltip,alt:$alt,class:$class,percentage:$percentage}'
      ''
    }/bin/waybar-${name}";
in {
  home.packages = with pkgs; [ yq ];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oa: {
      mesonFlags = (oa.mesonFlags or [ ]) ++ [ "-Dexperimental=true" ];
    });
    systemd.enable = true;
    settings = {
      primary = {
        layer = "top";
        position = "top";
        modules-left = [ "pulseaudio" "cpu" "custom/weather" ]
          ++ (lib.optionals config.wayland.windowManager.sway.enable [
            "sway/workspaces"
            "sway/mode"
          ]) ++ (lib.optionals config.wayland.windowManager.hyprland.enable [
            "hyprland/workspaces"
            "hyprland/submap"
          ]) ++ [ "custom/currentplayer" "custom/player" ];
        modules-center =
          (lib.optionals config.wayland.windowManager.hyprland.enable
            [ "hyprland/window" ])
          ++ (lib.optionals config.wayland.windowManager.sway.enable
            [ "sway/window" ]);

        modules-right = [
          "network"
          "tray"
          "battery"
          "backlight"
          "clock"
          "custom/wallpaper"
          "custom/power-menu"
          "custom/hostname"
        ];

        clock = {
          interval = 1;
          format = "{:W%W %d/%m/%Y %H:%M}";
          format-alt = "{:%Y-%m-%d %H:%M:%S %z}";
          on-click-left = "mode";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "  ";
          format-icons = {
            headphone = "󰋋";
            headset = "󰋎";
            portable = "";
            default = [ "" "" "" ];
          };
          on-click = pavucontrol;
        };
        cpu = {
          tooltip = true;
          format = "  {}%";
          states = {
            heavy = 70;
            full = 90;
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "󰒳";
            deactivated = "󰒲";
          };
        };
        battery = {
          bat = "BAT0";
          adapter = "ADP0";
          interval = 20;
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          onclick = "";
        };
        "sway/window" = { max-length = 20; };
        "hyprland/window" = { max-length = 20; };
        network = {
          interval = 3;
          format-wifi = "   {essid}";
          format-ethernet = "󰈁  {ifname}";
          format-disconnected = "󰤭";
          tooltip-format = ''
            {ifname}
            {ipaddr}/{cidr}
            Up: {bandwidthUpBits}
            Down: {bandwidthDownBits}'';
          on-click = "${network-manager-script}";
        };
        "custom/hostname" = { exec = "echo $USER@$HOSTNAME"; };
        "custom/gamemode" = {
          exec-if = "${gamemoded} --status | ${grep} 'is active' -q";
          interval = 2;
          return-type = "json";
          exec = jsonOutput "gamemode" { tooltip = "Gamemode is active"; };
          format = " ";
        };
        "custom/gammastep" = {
          interval = 5;
          return-type = "json";
          exec = jsonOutput "gammastep" {
            pre = ''
              if unit_status="$(${systemctl} --user is-active gammastep)"; then
                status="$unit_status ($(${journalctl} --user -u gammastep.service -g 'Period: ' | ${tail} -1 | ${cut} -d ':' -f6 | ${xargs}))"
              else
                status="$unit_status"
              fi
            '';
            alt = "\${status:-inactive}";
            tooltip = "Gammastep is $status";
          };
          format = "{icon}";
          format-icons = {
            "activating" = "󰁪 ";
            "deactivating" = "󰁪 ";
            "inactive" = "? ";
            "active (Night)" = " ";
            "active (Nighttime)" = " ";
            "active (Transition (Night)" = " ";
            "active (Transition (Nighttime)" = " ";
            "active (Day)" = " ";
            "active (Daytime)" = " ";
            "active (Transition (Day)" = " ";
            "active (Transition (Daytime)" = " ";
          };
          on-click =
            "${systemctl} --user is-active gammastep && ${systemctl} --user stop gammastep || ${systemctl} --user start gammastep";
        };
        "custom/currentplayer" = {
          interval = 2;
          return-type = "json";
          exec = jsonOutput "currentplayer" {
            pre = ''
              player="$(${playerctl} status -f "{{playerName}}" 2>/dev/null || echo "No player active" | ${cut} -d '.' -f1)"
              count="$(${playerctl} -l 2> /dev/null | ${wc} -l)"
              if ((count > 1)); then
                more=" +$((count - 1))"
              else
                more=""
              fi
            '';
            alt = "$player";
            tooltip = "$player ($count available)";
            text = "$more";
          };
          format = "{icon}{}";
          format-icons = {
            "No player active" = " ";
            "Celluloid" = "󰎁 ";
            "spotify" = "󰓇 ";
            "ncspot" = "󰓇 ";
            "qutebrowser" = "󰖟 ";
            "firefox" = " ";
            "discord" = " 󰙯 ";
            "sublimemusic" = " ";
            "kdeconnect" = "󰄡 ";
            "chromium" = " ";
          };
          on-click = "${playerctld} shift";
          on-click-right = "${playerctld} unshift";
        };
        "custom/player" = {
          exec-if = "${playerctl} status 2> /dev/null";
          exec =
            "${playerctl} metadata --format '{text: {{title}} - {{artist}}, alt: {{status}}, tooltip: {{title}} - {{artist}} ({{album}})}' 2> /dev/null | ${pkgs.yq}/bin/yq | ${jq} -c";
          return-type = "json";
          interval = 2;
          max-length = 30;
          format = "{icon} {}";
          format-icons = {
            "Playing" = "󰐊";
            "Paused" = "󰏤 ";
            "Stopped" = "󰓛";
          };
          on-click = "${playerctl} play-pause";
        };
        "custom/weather" = {
          exec = "nix-shell ${weather-py}";
          restart-interval = 300;
          return-type = "json";
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon}";
          tooltip = true;
          format-alt = "<small>{percent}%</small>";
          format-icons = [ "󱩎 " "󱩏 " "󱩐 " "󱩑 " "󱩒 " "󱩓 " "󱩔 " "󱩕 " "󱩖 " "󰛨 " ];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          smooth-scrolling-threshold = "2400";
          tooltip-format = "Brightness {percent}%";
        };
        "custom/wallpaper" = {
          format = " 󰔉 ";
          on-click = "${wallpaper-script}";
        };
        "custom/power-menu" = {
          format = " ⏻ ";
          on-click = "${powermenu-script} &";
        };
      };
    };
    style = let inherit (config.colorscheme) colors;
    in ''
      * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: Material Design Icons, JetBrainsMono Nerd Font, Iosevka Nerd Font;
        font-size: 10pt;
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.5);
        color: #ffffff;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.1;
      }

      #window {
        color: #64727d;
      }

      #custom-hostname {
        background-color: #${colors.base05};
        color: #${colors.base00};
        padding-left: 15px;
        padding-right: 22px;
        margin: 0;
        border-radius: 0;
      }

      #clock,
      #temperature,
      #mpris, 
      #cpu,
      #memory,
      #custom-media,
      #tray,
      #mode,
      #custom-lock,
      #workspaces,
      #idle_inhibitor,
      #custom-wallpaper, 
      #custom-power-menu,
      #custom-launcher,
      #custom-spotify,
      #custom-weather,
      #custom-weather.severe,
      #custom-weather.sunnyDay,
      #custom-weather.clearNight,
      #custom-weather.cloudyFoggyDay,
      #custom-weather.cloudyFoggyNight,
      #custom-weather.rainyDay,
      #custom-weather.rainyNight,
      #custom-weather.showyIcyDay,
      #custom-weather.snowyIcyNight,
      #custom-weather.default {
        color: #e5e5e5;
        border-radius: 6px;
        padding: 2px 10px;
        background-color: #252733;
        border-radius: 8px;
        font-size: 16px;

        margin-left: 4px;
        margin-right: 4px;

        margin-top: 8.5px;
        margin-bottom: 8.5px;
      }
      #temperature{
        color: #7a95c9;
      }
      #cpu {
        color: #fb958b;
      }

      #memory {
        color: #a1c999;
      }

      #workspaces button {
        color: #7a95c9;
        box-shadow: inset 0 -3px transparent;

        padding-right: 3px;
        padding-left: 4px;

        margin-left: 0.1em;
        margin-right: 0em;
        transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }

      #workspaces button.active {
        color: #ecd3a0;
        padding-left: 1px;
        padding-right: 12px;
        margin-left: 0em;
        margin-right: 0em;
        transition: all 0.5s cubic-bezier(0.55, -0.68, 0.48, 1.68);
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      #custom-launcher {
        margin-left: 12px;

        padding-right: 18px;
        padding-left: 14px;

        font-size: 22px;

        color: #7a95c9;

        margin-top: 8.5px;
        margin-bottom: 8.5px;
      }
      #bluetooth,
      #backlight,
      #battery,
      #pulseaudio,
      #network {
        background-color: #252733;
        padding: 0em 2em;

        font-size: 14px;

        padding-left: 7.5px;
        padding-right: 7.5px;

        padding-top: 3px;
        padding-bottom: 3px;

        margin-top: 7px;
        margin-bottom: 7px;
        border-radius: 8px;
        
        font-size: 10px;
      }

      #pulseaudio {
        color: #81A1C1;
        padding-left: 9px;
        font-size: 22px;
      }

      #pulseaudio.muted {
        color: #fb958b;
        padding-left: 9px;
        font-size: 22px;
      }

      #backlight {
        color: #ecd3a0;
        padding-right: 5px;
        padding-left: 8px;
        font-size: 21.2px;
      }

      #network {
        padding-left: 0.2em;
        color: #5E81AC;
        border-radius: 8px;
        padding-left: 14px;
        padding-right: 14px;
        font-size: 10px;
      }

      #network.disconnected {
        color: #fb958b;
      }

      #bluetooth {
        padding-left: 0.2em;
        color: #5E81AC;
        border-radius: 8px 0px 0px 8px;
        padding-left: 14px;
        padding-right: 14px;
        font-size: 20px;
      }

      #bluetooth.disconnected {
        color: #fb958b;
      }


      #battery {
        color: #8fbcbb;
        border-radius: 0px 8px 8px 0px;
        padding-right: 2px;
        font-size: 22px;
      }

      #battery.critical,
      #battery.warning,
      #battery.full,
      #battery.plugged {
        color: #8fbcbb;
        padding-left: 6px;
        padding-right: 12px;
        font-size: 22px;
      }

      #battery.charging { 
        font-size: 18px;
        padding-right: 13px;
        padding-left: 4px;
      }

      #battery.full,
      #battery.plugged {
        font-size: 22.5px;
        padding-right: 10px;
      }

      @keyframes blink {
        to {
          background-color: rgba(30, 34, 42, 0.5);
          color: #abb2bf;
        }
      }

      #battery.warning {
        color: #ecd3a0;
      }

      #battery.critical:not(.charging) {
        color: #fb958b;
      }

      #custom-lock {
        color: #ecd3a0;
        padding: 0 15px 0 15px;
        margin-left: 7px;
        margin-top: 7px;
        margin-bottom: 7px;
      }

      #clock {
        color: #8a909e;
        font-family: Iosevka Nerd Font;
        font-weight: bold;
        margin-top: 7px;
        margin-bottom: 7px;
      }

      #custom-power-menu {
        color: #e78284;
        margin-right: 12px;
        border-radius: 8px;
        padding: 0 6px 0 6.8px;
        margin-top: 7px;
        margin-bottom: 7px;
      }

      tooltip {
        font-family: Iosevka Nerd Font;
        border-radius: 15px;
        padding: 15px;
        background-color: #1f232b;
      }

      tooltip label {
        font-family: Iosevka Nerd Font;
        padding: 5px;
      }

      label:focus {
        background-color: #1f232b;
      }

      #tray {
        margin-right: 8px;
        margin-top: 7px;
        margin-bottom: 7px;
        font-size: 30px;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #eb4d4b;
      }

      #idle_inhibitor {
        background-color: #242933;
      }

      #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
      }
      #mpris,
      #custom-spotify {
        color: #abb2bf;
      }

      #custom-weather {
        font-family: Iosevka Nerd Font;
        font-size: 19px;
        color: #8a909e;
      }

      #custom-weather.severe {
        color: #eb937d;
      }

      #custom-weather.sunnyDay {
        color: #c2ca76;
      }

      #custom-weather.clearNight {
        color: #cad3f5;
      }

      #custom-weather.cloudyFoggyDay,
      #custom-weather.cloudyFoggyNight {
        color: #c2ddda;
      }

      #custom-weather.rainyDay,
      #custom-weather.rainyNight {
        color: #5aaca5;
      }

      #custom-weather.showyIcyDay,
      #custom-weather.snowyIcyNight {
        color: #d6e7e5;
      }

      #custom-weather.default {
        color: #dbd9d8;
      }

      #custom-wallpaper {
        color: #dbd9d8;
        padding-right: 5;
        padding-left: 0;
      }
    '';
  };
}
