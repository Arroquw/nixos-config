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

  gestures = if builtins.elem "${config.home.username}" touchpad_users then {
    workspace_swipe = true;
    workspace_swipe_min_speed_to_force = 5;
  } else
    { };

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
    hide_on_key_press = true;
    no_hardware_cursors = true;
    no_break_fs_vrr = true;
    min_refresh_rate = 60;
    inactive_timeout = 30;
    #allow_dumb_copy = true;

  };

  exec-once = let
    wallpaper-script =
      "${self.packages.${pkgs.system}.changewallpaper}/bin/changewallpaper";
    gecko = lib.optionals (config.home.username == "justin") [
      "gtk-launch steam"
      "gtk-launch discord"
      "push-to-talk -v -k BTN_EXTRA -n Pause /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse"
    ];
  in [
    "${pkgs.systemd}/bin/systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
    "${pkgs.poweralertd}/bin/poweralertd"
    "${wallpaper-script}"
    "${pkgs.blueman}/bin/blueman-applet"
    "${pkgs.xwaylandvideobridge}/bin/xwaylandvideobridge"
  ] ++ gecko;

  bind = let
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    #grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
    #grim = "${pkgs.grim}/bin/grim";
    terminal = "${pkgs.kitty}/bin/kitty";
    rofi = "${pkgs.rofi-wayland}/bin/rofi";
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
    #lock = "${pkgs.swaylock-effects}/bin/swaylock -fF";
    # https://github.com/hyprwm/hyprlock/issues/59#issuecomment-2023025535
    # Need to take a screenshot with `grim` before idling
    #hyprlockCmd = builtins.concatStringsSep " && " (map (m:
    #  let
    #    screen = m.name;
    #    screenShotfile = "/tmp/screenshot-${m.name}.png";
    #  in "${grim} -o ${screen} ${screenShotfile}") config.monitors);
    #"${grim} -o ${monitors.left} ${screenshotFiles.left} && ${grim} -o ${monitors.right} ${screenshotFiles.right} && ${pkgs.hyprlock}/bin/hyprlock";
    #lock = hyprlockCmd + " && ${pkgs.hyprlock}/bin/hyprlock";
    lock =
      "${pkgs.procps}/bin/pgrep hyprlock || ${pkgs.systemd}/bin/loginctl lock-session";
    keybind = "${self.packages.${pkgs.system}.hyprkeybinds}/bin/hyprkeybinds";
    hyprpicker =
      "${self.packages.${pkgs.system}.hyprpicker-script}/bin/hyprpicker-script";
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
    "$mainMod,P,pseudo,"
    "$mainMod,G,togglesplit,"
    "$mainMod,S,togglegroup,"
    "$mainMod,F,fullscreen,1"
    "$mainMod,F1,exec,${keybind}"
    "$mainMod SHIFT,C,exec,${hyprpicker}"
    ''$mainMod SHIFT,P,exec,sh -c "hyprprop >> /tmp/hyprprop.log"''
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
    "$mainMod SHIFT,Print,exec, ${hyprshot} -m region"
    "$mainMod,Print,exec, ${hyprshot} -m active -m window"
    "ALTSHIFT,Print,exec, ${hyprshot} -m active -m output --clipboard-only"
    "CTRLSHIFT,Print,exec, ${hyprshot} -m active -m window --clipboard-only"
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
    #",mouse:276, pass, class:^(vesktop)$" -- Vesktop does not have support for this yet, works on main discord app
  ] ++ discordPtt;

  bindm = [ "$mainMod,mouse:272,movewindow" "$mainMod,mouse:273,resizewindow" ];

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
      [ "opacity 0.96,discord" ];
  in [
    "animation,1,4,overshot,slide,^(rofi)$"
    "float,Rofi"
    "float,pavucontrol"
    "size 200,200,title:^(float_kitty)$"
    "float,title:^(full_kitty)$"
    "tile,title:^(kitty)$"
    "float,title:^(fly_is_kitty)$"
    "opacity 0.92,thunar"
    "opacity 0.88,obsidian"
    "opacity 0.85,neovim"
  ] ++ gecko;

  windowrulev2 = let
    gecko = lib.optionals (config.home.username == "justin") [
      "workspace 5 silent, title^()$,class:^(discord)$"
      "workspace 5 silent, title^()$,class:^(steam)$"
      "stayfocused, title:^()$,class:^(steam)$"
      "minsize 1 1, title:^()$,class:^(steam)$"
      "opacity 0.0 override,title:^(Alt1Lite overlay window)$"
      "fullscreenstate -1 2, title:^(GeForce NOW.*)$,class:^(msedge-.*)$"
      "noshortcutsinhibit, title:^(GeForce NOW.*)$,class:^(msedge-.*)$"
      "suppressevent fullscreen, title:^(GeForce NOW.*)$,class:^(msedge-.*)$"
    ];
  in [
    "float,class:^(blueman-manager)$"
    "float,class:^(org.twosheds.iwgtk)$"
    "float,class:^(blueberry.py)$"
    "float,class:^(xdg-desktop-portal-gtk)$"
    "opacity 0.0 override,class:^(xwaylandvideobridge)$"
    "noblur,title:^(Alt1Lite overlay window)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"
    "bordersize 0, floating:0, onworkspace:w[t1]"
    "rounding 0, floating:0, onworkspace:w[t1]"
    "bordersize 0, floating:0, onworkspace:w[tg1]"
    "rounding 0, floating:0, onworkspace:w[tg1]"
    "bordersize 0, floating:0, onworkspace:f[1]"
    "rounding 0, floating:0, onworkspace:f[1]"
  ] ++ gecko;

}
