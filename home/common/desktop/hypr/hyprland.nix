{ config, self, pkgs, lib, ... }:
let
  touchpad_users = [ "jusson" ];
  touchpad = {
    disable_while_typing = 1;
    natural_scroll = 1;
    clickfinger_behavior = 1;
    middle_button_emulation = 1;
    tap-to-click = 1;
  };
  closehook = pkgs.writeShellScriptBin "onwindowclose.sh" ''
    rscloseid="$(dd if=/dev/random count=4 bs=1 | xxd -p)"
    echo "''${1}" >"/tmp/hyprhook_close_''${rscloseid}"
    if cat "/tmp/hyprhook_close_''${rscloseid}" | sed -r 's/^},/}/' | jq -e 'select(.class == "runescape.exe")' >/dev/null; then
      xdotool search --classname "runescape.exe" | while read -r id; do
        if grep -q "720x480" <<<"$(xdotool getwindowgeometry "''${id}")"; then
            echo "Closing phantom window"
            xdotool windowclose "''${id}"
        fi
      done
    fi
  '';
in {
  "$mainMod" = "SUPER";
  input = {
    repeat_rate = 50;
    repeat_delay = 240;
    kb_layout = "us";
    kb_variant = "altgr-intl";
    kb_options = "compose:ralt";
    follow_mouse = 1;
    sensitivity = 0;
  } // (if builtins.elem "${config.home.username}" touchpad_users then {
    inherit touchpad;
  } else
    { });

  gestures = if builtins.elem "${config.home.username}" touchpad_users then
    [ "3, swipe, workspace" ]
  else
    [ ];

  "plugin" = {
    "hyprhook" = { "closeWindow" = "${closehook}/bin/onwindowclose.sh"; };
  };

  general = {
    layout = "dwindle";
    gaps_in = 1;
    gaps_out = 1;
    border_size = 2;
    "col.active_border" = "rgba(5e81acff)"; # 5e81ac ff
    "col.inactive_border" = "rgba(33333366)"; # 333333 66
    allow_tearing = true;
  };

  group = rec {
    insert_after_current = true;
    groupbar = {
      height = 10;
      scrolling = false;
      stacked = 1;
      text_color = "rgb(000000)";
      "col.active" =
        "rgba(2a4fc05e)"; # #2a4fc0 - these 4 are gradients so they blend in with the wallpaper
      "col.inactive" = "rgba(2527a55e)"; # #2527a5
      "col.locked_active" = "rgba(4a4aff5e)"; # #4a4aff
      "col.locked_inactive" = "rgba(152f755e)"; # #152f75
    };
    # use same colours for the borders, default config does this as well but with #ffff00, #777700, #ff5500, #775500
    "col.border_inactive" = groupbar."col.inactive";
    "col.border_active" = groupbar."col.active";
    "col.border_locked_inactive" = groupbar."col.locked_inactive";
    "col.border_locked_active" = groupbar."col.locked_active";
  };

  decoration = {
    rounding = 2;
    active_opacity = 0.99;
    inactive_opacity = 0.99;
    blur = {
      enabled = true;
      size = 8;
      passes = 3;
      ignore_opacity = true;
      new_optimizations = true;
    };
    shadow = {
      enabled = true;
      color = "rgba(a7caffff)"; # #a7caff
      range = 15;
      color_inactive = "rgba(00000050)"; # #000000
    };
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
  };

  master = { new_on_top = true; };

  render = { direct_scanout = 1; };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    key_press_enables_dpms = true;
    mouse_move_enables_dpms =
      if "${config.home.username}" != "justin" then true else false;
    vfr = true;
    allow_session_lock_restore = true;
  };

  cursor = {
    sync_gsettings_theme = true;
    hide_on_key_press = true;
    no_hardware_cursors = 1;
    no_break_fs_vrr = 2;
    min_refresh_rate = 60;
    use_cpu_buffer = 2;
  };

  exec-once = let
    wallpaper-script =
      "${self.packages.${pkgs.system}.changewallpaper}/bin/changewallpaper";
    gecko = lib.optionals (config.home.username == "justin") [
      "gtk-launch steam"
      "gtk-launch discord"
      "push-to-talk -v -k BTN_EXTRA -n Pause /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse"
      "push-to-talk -v -k KEY_PAUSE -n Pause /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd"
    ];
  in [
    "${
      lib.getExe' pkgs.systemd "systemctl"
    } --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
    "${lib.getExe' pkgs.poweralertd "poweralertd"}"
    "${wallpaper-script}"
    "${lib.getExe' pkgs.blueman "blueman-applet"}"
  ] ++ gecko;

  bind = let
    playerctl = "${lib.getExe' pkgs.playerctl "playerctl"}";
    #grimshot = "${lib.getExe' pkgs.sway-contrib.grimshot "grimshot"}";
    #grim = "${lib.getExe' pkgs.grim "grim"}";
    terminal = "${lib.getExe' pkgs.kitty "kitty"}";
    rofi = "${lib.getExe' pkgs.rofi "rofi"}";
    thunar = "${lib.getExe' pkgs.xfce.thunar "thunar"}";
    wlogout = "${lib.getExe' pkgs.wlogout "wlogout"}";
    htop = "${lib.getExe' pkgs.htop "htop"}";
    rofimoji = "${lib.getExe' pkgs.rofimoji "rofimoji"}";
    wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
    speedcrunch = "${lib.getExe' pkgs.speedcrunch "speedcrunch"}";
    spotify = "${lib.getExe' pkgs.spotify "spotify"}";
    gtk-launch = "${lib.getExe' pkgs.gtk3 "gtk-launch"}";
    xdg-mime = "${lib.getExe' pkgs.xdg-utils "xdg-mime"}";
    defaultApp = type: "${gtk-launch} $(${xdg-mime} query default ${type})";
    browser = defaultApp "x-scheme-handler/https";
    #lock = "${lib.getExe' pkgs.swaylock-effects "swaylock -fF"}";
    # https://github.com/hyprwm/hyprlock/issues/59#issuecomment-2023025535
    # Need to take a screenshot with `grim` before idling
    #hyprlockCmd = builtins.concatStringsSep " && " (map (m:
    #  let
    #    screen = m.name;
    #    screenShotfile = "/tmp/screenshot-${m.name}.png";
    #  in "${grim} -o ${screen} ${screenShotfile}") config.monitors);
    #"${grim} -o ${monitors.left} ${screenshotFiles.left} && ${grim} -o ${monitors.right} ${screenshotFiles.right} && ${lib.getExe' pkgs.hyprlock "hyprlock"}";
    #lock = hyprlockCmd + " && ${lib.getExe' pkgs.hyprlock "hyprlock"}";
    lock = ''
      ${lib.getExe' pkgs.procps "pgrep"} hyprlock || ${
        lib.getExe' pkgs.systemd "loginctl"
      } "lock-session"
    '';
    keybind = "${self.packages.${pkgs.system}.hyprkeybinds}/bin/hyprkeybinds";
    hyprpicker =
      "${self.packages.${pkgs.system}.hyprpicker-script}/bin/hyprpicker-script";
    resolution-script =
      "${self.packages.${pkgs.system}.hypr-resolution}/bin/hypr-resolution";
    hyprshot = "${self.packages.${pkgs.system}.hyprshot}/bin/hyprshot";
    discordPtt = lib.optionals (config.home.username == "justin")
      [ ",mouse:276, pass, class:^(discord)$" ];
  in [
    "$mainMod,return,exec,${terminal}"
    "$mainMod,Q,killactive,"
    "$mainMod,R,exec,${rofi} -show drun"
    "$mainMod,E,exec,${thunar}"
    "$mainMod,M,exit,"
    "$mainMod,T,togglefloating,"
    "$mainMod SHIFT,P,pseudo,"
    "$mainMod,G,togglesplit,"
    "$mainMod,S,togglegroup,"
    "$mainMod,F,fullscreen,1"
    "$mainMod,F1,exec,${keybind}"
    "$mainMod SHIFT,C,exec,${hyprpicker}"
    ''$mainMod CTRL,P,exec,sh -c "hyprprop >> /tmp/hyprprop.log"''
    "$mainMod SHIFT,F,fullscreen,0"
    "$mainMod,ESCAPE,exec,${wlogout}"
    "$mainMod,SPACE,exec,${lock}"
    "$mainMod SHIFT,E,exec,${rofimoji} --keybinding-copy ctrl+c"
    "ALTCTRL,DELETE,exec,${htop}"
    "$mainMod,up,changegroupactive,b"
    "$mainMod,down,changegroupactive,f"
    "$mainMod,right,workspace,+1"
    "$mainMod,left,workspace,-1"
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
    "$mainMod ALT,Print,exec, ${hyprshot} -m active -m output"
    "$mainMod SHIFT,Print,exec, ${hyprshot} -zm region"
    "$mainMod,Print,exec, ${hyprshot} -m active -m window"
    "ALTSHIFT,Print,exec, ${hyprshot} -m active -m output --clipboard-only"
    "CTRLSHIFT,Print,exec, ${hyprshot} -m active -m window --clipboard-only"
    "SHIFT,Print,exec, ${hyprshot} -zm region --clipboard-only"
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
    "$mainMod,P,exec,${resolution-script}"
    #",mouse:276, pass, class:^(vesktop)$" -- Vesktop does not have support for this yet, works on main discord app
  ] ++ discordPtt;

  bindm = [ "$mainMod,mouse:272,movewindow" "$mainMod,mouse:273,resizewindow" ];

  bindr = let
    wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
    playerctl = "${lib.getExe' pkgs.playerctl "playerctl"}";
    brightnessctl = "${lib.getExe' pkgs.brightnessctl "brightnessctl"}";
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

  # Map the monitors set to hyprland config strings. Uses monitor description by default if set, otherwise name (e.g. DP-2)
  monitor = map (m:
    let
      resolution =
        "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
      position = "${toString m.x}x${toString m.y}";
      monitorString = if m.desc != null then "desc:${m.desc}" else "${m.name}";
      vrr = if m.vrr != null then ",vrr,${toString m.vrr}" else "";
    in "${monitorString},${
      if m.enabled then "${resolution},${position},1${vrr}" else "disable,1"
    }") config.monitors;

  #  workspace as string instead of list: (only allows one workspace per monitor to be specified)
  #  workspace = map (m:
  #    let monitorString = if m.name == null then "desc:${m.desc}" else "${m.name}";
  #    in "${m.workspace},monitor:${monitorString}")
  #    (lib.filter (m: m.enabled && m.workspace != null) config.monitors);

  # Gotta concat to take the double list into account
  workspace = builtins.concatMap (m:
    let
      monitorString = if m.desc != null then "desc:${m.desc}" else "${m.name}";
    in map (w: "${w}, monitor:${monitorString}, default:true") m.workspace)
    (lib.filter (m: m.enabled && m.workspace != null) config.monitors) ++ [
      "w[t1], gapsout:0, gapsin:0"
      "w[tg1], gapsout:0, gapsin:0"
      "f[1], gapsout:0, gapsin:0"
    ];

  windowrule = let
    gecko = lib.optionals (config.home.username == "justin")
      [ "opacity 0.96,class:^(discord)$" ];
  in [
    "match:class rofi,animation overshoot 1 4 slide"
    "match:class rofi, float on"
    "match:class org.pulseaudio.pavucontrol, float on"
    "size 200 200,match:title float_kitty"
    "float on,match:title full_kitty"
    "tile on,match:title kitty"
    "float on,match:title fly_is_kitty"
    "opacity 0.92,match:class thunar"
    "opacity 0.88,match:class obsidian"
    "opacity 0.85,match:class neovim"
  ] ++ gecko;

  windowrulev2 = let
    gecko = lib.optionals (config.home.username == "justin") [
      "workspace 5 silent, title^()$,class:^(discord)$"
      "workspace 5 silent, title^()$,class:^(steam)$"
      "stayfocused, title:^()$,class:^(steam)$"
      "minsize 1 1, title:^()$,class:^(steam)$"
      "tag +alt1app, title:^(Alt1 Lite app)$"
      "nomaxsize, tag:alt1app"
      "float, tag:alt1app"
      "noblur, tag:alt1app"
      "noinitialfocus, tag:alt1app"
      "noborder, tag:alt1app"
      "immediate, tag:alt1app"
      "allowsinput, tag:alt1app"
      "tag +alt1overlay, title:^(Alt1Lite overlay window)$"
      # "pin, tag:alt1overlay"
      # "bordersize 5, tag:alt1overlay"
      "nofocus, tag:alt1overlay"
      "noinitialfocus, tag:alt1overlay"
      "nofollowmouse, tag:alt1overlay"
      "noblur, tag:alt1overlay"
      "noborder, tag:alt1overlay"
      "fullscreenstate -1 2, tag:alt1overlay"
      # "float, tag:alt1overlay"
      "size 2560 1390, tag:alt1overlay"
      "persistentsize, tag:alt1overlay"
      "suppressevent activate activatefocus fullscreen, tag:alt1overlay"
      "renderunfocused, tag:alt1overlay"
      "workspace 1, tag:alt1overlay"
      "tile, class:^(rs2client.exe)$"
      "workspace 1, class:^(rs2client.exe)$"
      "idleinhibit always, class:^(rs2client.exe)$"
      "workspace 1, tag:alt1"
      "workspace 3, class:^(jagexlauncher.exe)$"
      "renderunfocused, class:^(runescape.exe)$"
      "fullscreenstate -1 2, title:^(GeForce NOW.*)$,class:^(msedge-.*)$"
      "noshortcutsinhibit, title:^(GeForce NOW.*)$,class:^(msedge-.*)$"
      "suppressevent fullscreen, title:^(GeForce NOW.*)$,class:^(msedge-.*)$"
      "suppressevent fullscreen, title:^(Heroes of the Storm)$"
      "fullscreenstate -1 2, title:^(Heroes of the Storm)$"
      "workspace 1, title:^(Heroes of the Storm)$"
      "content:game, title:^(Factorio)$"
    ];
  in [
    "float,class:^(blueman-manager)$"
    "float,class:^(org.twosheds.iwgtk)$"
    "float,class:^(blueberry.py)$"
    "float,class:^(xdg-desktop-portal-gtk)$"
    "bordersize 0, floating:0, onworkspace:w[t1]"
    "rounding 0, floating:0, onworkspace:w[t1]"
    "bordersize 0, floating:0, onworkspace:w[tg1]"
    "rounding 0, floating:0, onworkspace:w[tg1]"
    "bordersize 0, floating:0, onworkspace:f[1]"
    "rounding 0, floating:0, onworkspace:f[1]"
  ] ++ gecko;

}
