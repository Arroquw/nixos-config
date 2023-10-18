{ lib, pkgs, config, self, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      input = {
        repeat_rate = 50;
        repeat_delay = 240;
        touchpad = {
          disable_while_typing = 1;
          natural_scroll = 1;
          clickfinger_behavior = 1;
          middle_button_emulation = 1;
          tap-to-click = 1;
        };
        kb_layout = "us";
        follow_mouse = 1;
        sensitivity = 0;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_min_speed_to_force = 5;
      };

      general = {
        layout = "dwindle";
        sensitivity = 1.0;
        gaps_in = 1;
        gaps_out = 1;
        border_size = 2;
        "col.active_border" = "0xff5e81ac";
        "col.inactive_border" = "0x66333333";
        apply_sens_to_raw = 0;
      };

      decoration = {
        rounding = 5;
        drop_shadow = true;
        shadow_range = 15;
        "col.shadow" = "0xffa7caff";
        "col.shadow_inactive" = "0x50000000";
      };

      blurls = "waybar";

      animations = {
        enabled = 1;
        bezier = "overshot,0.28,0.99,0.29,1.01";
        animation = [
          "windows,1,4,overshot,slide"
          "fadeIn,1,10,default"
          "workspaces,1,5.1,overshot,slide"
          "border,1,14,default"
        ];
      };

      dwindle = {
        pseudotile = 1;
        force_split = 0;
        animation = "windows,1,8,default,popin 80%";
        no_gaps_when_only = true;
      };

      master = {
        new_on_top = true;
        no_gaps_when_only = true;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        vfr = true;
        allow_session_lock_restore = true;
      };

      exec = let
        wallpaper-script =
          "${self.packages.${pkgs.system}.changewallpaper}/bin/changewallpaper";
      in [
        "${pkgs.wl-clipboard}/bin/wl-clipboard-history -t"
        "${pkgs.poweralertd}/bin/poweralertd"
        "${wallpaper-script}"
        "${pkgs.blueman}/bin/blueman-applet"
        "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland DBUS_SESSION_BUS_ADDRESS PATH"
        "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH"
      ];

      bind = let
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
        terminal = config.home.sessionVariables.TERMINAL;
        rofi = "${pkgs.rofi}/bin/rofi";
        thunar = "${pkgs.xfce.thunar}/bin/thunar";
        wlogout = "${pkgs.wlogout}/bin/wlogout";
        htop = "${pkgs.htop}/bin/htop";
        rofimoji = "${pkgs.rofimoji}/bin/rofimoji";
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        speedcrunch = "${pkgs.speedcrunch}/bin/speedcrunch";
        spotify = "${pkgs.spotify}/bin/spotify";
        gtk-launch = "${pkgs.gtk3}/bin/gtk-launch";
        xdg-mime = "${pkgs.xdg-utils}/bin/xdg-mime";
        defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";
        browser = defaultApp "x-scheme-handler/https";
        swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
        keybind =
          "${self.packages.${pkgs.system}.hyprkeybinds}/bin/hyprland-keybinds";
        hyprpicker = "${
            self.packages.${pkgs.system}.hyprpicker-script
          }/bin/hyprpicker-script";
        hyprshot = "${self.packages.${pkgs.system}.hyprshot}/bin/hyprshot";
      in [
        "$mainMod,return,exec,${terminal}"
        "$mainMod,Q,killactive,"
        "$mainMod,R,exec,${rofi} -show drun"
        "$mainMod,E,exec,${thunar}"
        "$mainMod,M,exit,"
        "$mainMod,T,togglefloating,"
        "$mainMod,P,pseudo,"
        "$mainMod,G,togglesplit,"
        "$mainMod,S,togglegroup,"
        "$mainMod,F,fullscreen,1"
        "$mainMod,F1,exec,${keybind}/bin/keybind"
        "$mainMod SHIFT,C,exec,${hyprpicker}/bin/hyprpicker.sh"
        "$mainMod SHIFT,F,fullscreen,0"
        "$mainMod,ESCAPE,exec,${wlogout}"
        "$mainMod,SPACE,exec,${swaylock} -fF"
        "$mainMod SHIFT,E,exec,${rofimoji} --keybinding-copy ctrl+c"
        "ALTCTRL,DELETE,exec,${htop}"
        "$mainMod,left,changegroupactive,b"
        "$mainMod,right,changegroupactive,f"
        "$mainMod,up,workspace,+1"
        "$mainMod,down,workspace,-1"
        "$mainMod SHIFT,s,moveintogroup,r"
        "$mainMod,J,movefocus,d"
        "$mainMod,K,movefocus,u"
        "$mainMod,H,movefocus,l"
        "$mainMod,L,movefocus,r"
        "$mainMod CTRL,J,movewindoworgroup,l"
        "$mainMod CTRL,K,movewindoworgroup,r"
        "$mainMod CTRL,H,movewindoworgroup,u"
        "$mainMod CTRL,L,movewindoworgroup,d"
        "$mainMod SHIFT,J,movewindow,l"
        "$mainMod SHIFT,K,movewindow,r"
        "$mainMod SHIFT,H,movewindow,u"
        "$mainMod SHIFT,L,movewindow,d"

        "$mainMod,mouse_down,workspace,e+1"
        "$mainMod,mouse_up,workspace,e-1"
        ",XF86AudioMute,exec,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioPlay,exec,${playerctl} play-pause -i firefox"
        ",XF86Explorer,exec,${thunar}"
        ",XF86HomePage,exec,${browser}"
        ",XF86Calculator,exec,${speedcrunch}"
        ",XF86Tools,exec,${spotify}"
        ",XF86AudioStop,exec,${playerctl} stop"
        "$mainMod SHIFT,Print,exec,${grimshot} --notify save active"
        "SHIFT,Print,exec, ${hyprshot} -m region --clipboard-only"
        "$mainMod SHIFT,RETURN,layoutmsg,swapwithmaster"
        "$mainMod,1,workspace,1"
        "$mainMod,2,workspace,2"
        "$mainMod,3,workspace,3"
        "$mainMod,4,workspace,4"
        "$mainMod,5,workspace,5"
        "$mainMod,6,workspace,6"
        "$mainMod,7,workspace,7"
        "$mainMod,8,workspace,8"
        "$mainMod,9,workspace,9"
        "$mainMod,0,workspace,10"
        "$mainMod SHIFT,1,movetoworkspacesilent,1"
        "$mainMod SHIFT,2,movetoworkspacesilent,2"
        "$mainMod SHIFT,3,movetoworkspacesilent,3"
        "$mainMod SHIFT,4,movetoworkspacesilent,4"
        "$mainMod SHIFT,5,movetoworkspacesilent,5"
        "$mainMod SHIFT,6,movetoworkspacesilent,6"
        "$mainMod SHIFT,7,movetoworkspacesilent,7"
        "$mainMod SHIFT,8,movetoworkspacesilent,8"
        "$mainMod SHIFT,9,movetoworkspacesilent,9"
        "$mainMod SHIFT,0,movetoworkspacesilent,10"
      ];

      bindm =
        [ "$mainMod,mouse:272,movewindow" "$mainMod,mouse:273,resizewindow" ];

      bindr = let
        wpctl = "${pkgs.wireplumber}/bin/wpctl";
        playerctl = "${pkgs.playerctl}/bin/playerctl";
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in [
        "$mainMod SHIFT,left,resizeactive,-40 0"
        "$mainMod SHIFT,right,resizeactive,40 0"
        "$mainMod SHIFT,up,resizeactive,0 -40"
        "$mainMod SHIFT,down,resizeactive,0 40"
        ",XF86AudioRaiseVolume,exec,${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%+"
        ",XF86AudioLowerVolume,exec,${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%-"
        ",XF86AudioNext,exec,${playerctl} next -i firefox"
        ",XF86AudioPrev,exec,${playerctl} previous -i firefox"
        ",XF86MonBrightnessUp,exec,${brightnessctl} set 10%+"
        ",XF86MonBrightnessDown,exec,${brightnessctl} set 10%-"
      ];

      monitor = map (m:
        let
          resolution = "${toString m.width}x${toString m.height}@${
              toString m.refreshRate
            }";
          position = "${toString m.x}x${toString m.y}";
        in "${m.name},${
          if m.enabled then "${resolution},${position},1" else "disable"
        }") config.monitors;

      workspace = map (m: "${m.name},${m.workspace}")
        (lib.filter (m: m.enabled && m.workspace != null) config.monitors);
    };

    extraConfig = import ./config.nix {
      kb_variant = "";
      kb_options = "";
      monitor_config = "";
    };
  };
}
