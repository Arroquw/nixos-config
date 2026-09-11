{
  config,
  lib,
  pkgs,
  self,
  hostname,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  inherit (self.packages.${system}) changewallpaper;
  # Only the work laptop has a battery, a backlight and the work mounts.
  laptop = hostname == "lnxclnt2840";
  exec = pkg: bin: "exec ${lib.getExe' pkg bin}";
  inherit (config.colorscheme) palette;
  color = base: "#${palette.${base}}";
  lockCmd = pkgs.writeShellScript "session-lock" ''
    ${lib.getExe' pkgs.procps "pgrep"} hyprlock || ${lib.getExe' pkgs.systemd "loginctl"} lock-session
  '';
  suspendCmd = pkgs.writeShellScript "session-suspend" ''
    ${lib.getExe' pkgs.playerctl "playerctl"} pause
    ${lib.getExe' pkgs.alsa-utils "amixer"} set Master mute
    ${lib.getExe' pkgs.systemd "systemctl"} suspend
  '';
in
{
  # Noctalia provides the bar, notifications, network panel, app launcher and
  # session menu. The rest of what it can do is switched off below because an
  # existing tool already owns it: lock (hyprlock), idle (hypridle), wallpaper
  # (swaybg via changewallpaper), night light (wlsunset) and clipboard history
  # (cliphist).
  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    checkConfig = true;

    # nixos-unstable still ships 5.0.1, whose Hyprland workspace widget can't
    # tell which workspace is focused on this Hyprland build
    package =
      if lib.versionOlder pkgs.noctalia.version "5.1.0" then
        pkgs.noctalia.overrideAttrs (_: {
          version = "5.1.0";
          src = pkgs.fetchFromGitHub {
            owner = "noctalia-dev";
            repo = "noctalia";
            tag = "v5.1.0";
            hash = "sha256-A7ehoEnAJw4k1Qwpr/WkOkLXWZAVU970uB+sm6nBxP0=";
          };
        })
      else
        pkgs.noctalia;

    # Built from the nix-colors scheme in home/common/global.nix
    customPalettes.nix-colors.dark = {
      mSurface = color "base00";
      mOnSurface = color "base05";
      mSurfaceVariant = color "base02";
      mOnSurfaceVariant = color "base04";
      mPrimary = color "base0D";
      mOnPrimary = color "base00";
      mSecondary = color "base0E";
      mOnSecondary = color "base00";
      mTertiary = color "base0B";
      mOnTertiary = color "base00";
      mError = color "base0F";
      mOnError = color "base00";
      mOutline = color "base03";
      mShadow = color "base01";
      mHover = color "base03";
      mOnHover = color "base06";
    };

    settings = {
      shell = {
        setup_wizard_enabled = false;
        clipboard_enabled = false;

        session.actions = [
          {
            action = "lock";
            command = "${lockCmd}";
            shortcut = "1";
          }
          {
            action = "suspend";
            command = "${suspendCmd}";
            countdown_seconds = 3.0;
            shortcut = "2";
          }
          {
            action = "logout";
            command = lib.getExe pkgs.hyprshutdown;
            countdown_seconds = 3.0;
            shortcut = "3";
          }
          {
            action = "reboot";
            countdown_seconds = 3.0;
            shortcut = "4";
          }
          {
            action = "shutdown";
            countdown_seconds = 3.0;
            shortcut = "5";
            variant = "destructive";
          }
        ];
      };

      theme = {
        source = "custom";
        custom_palette = "nix-colors"; # see customPalettes above
      };

      wallpaper.enabled = false;

      # Besides its lock screen, noctalia takes a logind sleep inhibitor and
      # locks on PrepareForSleep, which would stack a second lock screen on top
      # of hypridle's `before_sleep_cmd = loginctl lock-session`.
      lockscreen = {
        enabled = false;
        lock_before_suspend = false;
      };

      location.address = "Haarsteeg";

      audio = {
        enable_sounds = true;
        notification_sound = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/window-attention.oga";
      };
      notification = {
        position = "top_right";
        layer = "overlay";
        filter.spotify = {
          enabled = true;
          match = "spotify";
          play_sound = false;
        };
      };

      bar.default = {
        margin_ends = 0;
        concave_edge_corners = false;
        radius = 0;

        # Size and look. These are noctalia's defaults, listed here to tune.
        thickness = 34;
        padding = 14;
        widget_spacing = 6;
        font_scale = 1.0;
        background_opacity = 1.0;
        shadow = true;
        capsule = false;

        start = [
          "output_volume"
          "input_volume"
          "cpu"
          "weather"
          "workspaces"
          "media"
        ];
        center = [ "active_window" ];
        end = [
          "network"
          "tray"
        ]
        ++ lib.optionals laptop [
          "work-mounts"
          "battery"
          "brightness"
        ]
        ++ [
          "caffeine"
          "date"
          "wallpaper-button"
          "session"
          "hostname"
        ];
      };

      widget = {
        output_volume = {
          type = "volume";
          device = "output";
          actions.left = exec pkgs.pavucontrol "pavucontrol";
        };
        input_volume = {
          type = "volume";
          device = "input";
          actions.left = "exec ${lib.getExe' pkgs.pamixer "pamixer"} --default-source -t";
        };
        network = {
          type = "network";
          actions.left = "panel-toggle control-center network";
        };
        date = {
          type = "clock";
          format = "{:%a %d/%m/%Y %R W%V}";
        };
        "wallpaper-button" = {
          type = "custom_button";
          glyph = "photo";
          tooltip = "Random wallpaper";
          actions.left = exec changewallpaper "changewallpaper";
        };
        hostname = {
          type = "custom_button";
          glyph = "user";
          label = "${config.home.username}@${hostname}";
        };
        "work-mounts" = {
          type = "custom_button";
          glyph = "disc";
          tooltip = "Restart work mounts";
          actions.left = "exec ${config.home.homeDirectory}/restart_mounts.sh";
        };
      };
    };
  };
}
