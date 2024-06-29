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
    kb_variant = "euro";
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
    "col.active_border" = "0xff5e81ac";
    "col.inactive_border" = "0x66333333";
    apply_sens_to_raw = 0;
    allow_tearing = true;
  };

  group = {
    groupbar = {
      height = 10;
      scrolling = false;
      stacked = true;
      text_color = "f5f5f5"; # #f5f5f5
      "col.inactive" = "0x4a5a70"; # #4a5a70
      "col.active" = "0x252745"; # #252745
      "col.locked_inactive" = "0x4a5a5f"; # #4a5a5f
      "col.locked_active" = "0x152f45"; # #152f45
    };
  };

  decoration = {
    rounding = 2;
    drop_shadow = true;
    shadow_range = 15;
    "col.shadow" = "0xffa7caff";
    "col.shadow_inactive" = "0x50000000";
    active_opacity = 0.99;
    inactive_opacity = 0.99;
    blur = {
      enabled = true;
      size = 8;
      passes = 3;
      ignore_opacity = true;
      new_optimizations = true;
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
    no_gaps_when_only = true;
  };

  master = {
    new_on_top = true;
    no_gaps_when_only = true;
  };

  misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    key_press_enables_dpms = true;
    mouse_move_enables_dpms =
      if "${config.home.username}" != "justin" then true else false;
    vfr = true;
    allow_session_lock_restore = true;
  };

  cursor = { hide_on_key_press = true; };

  exec-once = let
    wallpaper-script =
      "${self.packages.${pkgs.system}.changewallpaper}/bin/changewallpaper";
    discord = "${pkgs.discord}/bin/discord";
    steam = "${pkgs.xdg-utils}/bin/xdg-open steam://";
    idle-inhibit = "${
        self.packages.${pkgs.system}.sway-audio-idle-inhibit
      }/bin/sway-audio-idle-inhibit";
    gecko = lib.optionals (config.home.username == "justin") [
      "env -u NIXOS_OZONE_WL ${discord} --use-gl=desktop"
      "${steam}"
    ];
  in [
    "${idle-inhibit} &"
    "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
    "${pkgs.poweralertd}/bin/poweralertd"
    "${wallpaper-script}"
    "${pkgs.blueman}/bin/blueman-applet"
  ] ++ gecko;

  bind = let
    playerctl = "${pkgs.playerctl}/bin/playerctl";
    #grimshot = "${pkgs.sway-contrib.grimshot}/bin/grimshot";
    grim = "${pkgs.grim}/bin/grim";
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
    hyprlockCmd = builtins.concatStringsSep " && " (map (m:
      let
        screen = m.name;
        screenShotfile = "/tmp/screenshot-${m.name}.png";
      in "${grim} -o ${screen} ${screenShotfile}") config.monitors);
    #"${grim} -o ${monitors.left} ${screenshotFiles.left} && ${grim} -o ${monitors.right} ${screenshotFiles.right} && ${pkgs.hyprlock}/bin/hyprlock";
    lock = hyprlockCmd + " && ${pkgs.hyprlock}/bin/hyprlock";
    keybind = "${self.packages.${pkgs.system}.hyprkeybinds}/bin/hyprkeybinds";
    hyprpicker =
      "${self.packages.${pkgs.system}.hyprpicker-script}/bin/hyprpicker-script";
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
    "$mainMod,F1,exec,${keybind}"
    "$mainMod SHIFT,C,exec,${hyprpicker}"
    ''$mainMod SHIFT,P,exec,sh -c "hyprprop >> /tmp/hyprprop.log"''
    "$mainMod SHIFT,F,fullscreen,0"
    "$mainMod,ESCAPE,exec,${wlogout}"
    "$mainMod,SPACE,exec,${lock}"
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
    ",mouse:276, pass, ^discord$"
  ];

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

  monitor = map (m:
    let
      resolution =
        "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
      position = "${toString m.x}x${toString m.y}";
      monitorString = if m.desc != null then "desc:${m.desc}" else "${m.name}";
      vrr = if m.vrr != null then ",vrr,${toString m.vrr}" else "";
    in "${monitorString},${
      if m.enabled then "${resolution},${position},1${vrr}" else "disable"
    }") config.monitors;

  #  workspace as string instead of list: (only allows one workspace per monitor to be specified)
  #  workspace = map (m:
  #    let monitorString = if m.name == null then "desc:${m.desc}" else "${m.name}";
  #    in "${m.workspace},monitor:${monitorString}")
  #    (lib.filter (m: m.enabled && m.workspace != null) config.monitors);

  # Gotta concat to take the double list into account
  workspace = builtins.concatMap (m:
    let
      monitorString = if m.name == null then "desc:${m.desc}" else "${m.name}";
    in map (w: "${w},monitor:${monitorString}") m.workspace)
    (lib.filter (m: m.enabled && m.workspace != null) config.monitors);

  windowrule = [
    "animation,1,4,overshot,slide,^(rofi)$"
    "float,Rofi"
    "float,pavucontrol"
    "size 200,200,title:^(float_kitty)$"
    "float,title:^(full_kitty)$"
    "tile,title:^(kitty)$"
    "float,title:^(fly_is_kitty)$"
    "opacity 0.92,thunar"
    "opacity 0.96,discord"
    "opacity 0.88,obsidian"
    "opacity 0.85,neovim"
  ];

  windowrulev2 = [
    "float,class:^(blueman-manager)$"
    "float,class:^(org.twosheds.iwgtk)$"
    "float,class:^(blueberry.py)$"
    "float,class:^(xdg-desktop-portal-gtk)$"
    "idleinhibit,fullscreen:1"
    "opacity 0.0 override,class:^(xwaylandvideobridge)$"
    "noanim,class:^(xwaylandvideobridge)$"
    "noinitialfocus,class:^(xwaylandvideobridge)$"
    "maxsize 1 1,class:^(xwaylandvideobridge)$"
    "noblur,class:^(xwaylandvideobridge)$"
    "stayfocused, title:^()$,class:^(steam)$"
    "minsize 1 1, title:^()$,class:^(steam)$"
    "workspace 5 silent, title^()$,class:^(discord)$"
  ];

}