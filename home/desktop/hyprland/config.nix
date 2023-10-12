{ kb_variant ? "", kb_options ? "", monitor_config ? "", ... }: ''
  ########################################################################################

   ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗ ███████╗
  ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝ ██╔════╝
  ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗███████╗
  ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║╚════██║
  ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝███████║
   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝ ╚══════╝       

  #########################################################################################

  # You have to change this based on your monitor
  monitor=eDP-1,1920x1080@60.0,1920x1440,1
  monitor=DP-5,highres,0x0,1
  monitor=DP-4,2560x1440@60.0,1920x0,1
  ${monitor_config}
  # Status bar :) 
  exec-once=waybar
  exec-once = wl-clipboard-history -t
  # Notification 
  exec-once = mako &
  exec-once = poweralertd
  # Wallpaper
  exec-once= bash ~/.config/waybar/scripts/changewallpaper.sh
  # Bluetooth
  exec-once=blueman-applet # Make sure you have installed blueman + blueman-utils
  #bindl=,switch:off:"Lid Switch",exec,hyprctl keyword monitor "eDP-1, disable"
  #bindl=,switch:on:"Lid Switch",exec,hyprctl keyword monitor "eDP-1, 1920x1080, 2560x0, 1"
  exec-once = dbus-update-actvation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland DBUS_SESSION_BUS_ADDRESS
  exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
  # Screen Sharing
  #exec-once = ~/.config/hypr/scripts/screensharing.sh

  #env = XDG_SESSION_TYPE,wayland
  #env = WLR_NO_HARDWARE_CURSORS,1
  env = XCURSOR_SIZE,16

  input {
    repeat_rate=50
    repeat_delay=240

    touchpad {
      disable_while_typing=1
      natural_scroll=1
      clickfinger_behavior=1
      middle_button_emulation=0
      tap-to-click=1
    }
    kb_layout = us
    kb_variant = ${kb_variant}
    kb_model =
    kb_options = ${kb_options}
    kb_rules =
    follow_mouse = 1
    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }
  gestures { 
    workspace_swipe=true 
    workspace_swipe_min_speed_to_force=5
  }

  general {
      layout=dwindle
      sensitivity=1.0 # for mouse cursor

      gaps_in=1
      gaps_out=1
      border_size=2
      col.active_border=0xff5e81ac
      col.inactive_border=0x66333333

      apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
  }

  decoration {
      rounding=5
      drop_shadow=true
      shadow_range=15
      col.shadow=0xffa7caff #86AAEC
      col.shadow_inactive=0x50000000
  }

  # Blur for waybar 
  blurls=waybar

  animations {
      enabled=1
      bezier=overshot,0.28,0.99,0.29,1.01
      animation=windows,1,4,overshot,slide
      animation=fadeIn,1,10,default
      animation=workspaces,1,5.1,overshot,slide
      animation=border,1,14,default
  }

  dwindle {
      pseudotile=1 # enable pseudotiling on dwindle
      force_split=0animation=windows,1,8,default,popin 80%
      no_gaps_when_only = true
  }

  master {
    new_on_top=true
    no_gaps_when_only = true
  }

  misc {
    disable_hyprland_logo=true
    disable_splash_rendering=true
    mouse_move_enables_dpms=true
    vfr = true
    hide_cursor_on_touch = true
  }

  ########################################################################################
  ██╗    ██╗██╗███╗   ██╗██████╗  ██████╗ ██╗    ██╗███████╗    ██████╗ ██╗   ██╗██╗     ███████╗███████╗
  ██║    ██║██║████╗  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝    ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
  ██║ █╗ ██║██║██╔██╗ ██║██║  ██║██║   ██║██║ █╗ ██║███████╗    ██████╔╝██║   ██║██║     █████╗  ███████╗
  ██║███╗██║██║██║╚██╗██║██║  ██║██║   ██║██║███╗██║╚════██║    ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
  ╚███╔███╔╝██║██║ ╚████║██████╔╝╚██████╔╝╚███╔███╔╝███████║    ██║  ██║╚██████╔╝███████╗███████╗███████║
   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═════╝  ╚═════╝  ╚══╝╚══╝ ╚══════╝    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝
  ########################################################################################


  # Float Necessary Windows
  windowrule=animation,1,4,overshot,slide,^(rofi)$
  windowrule=float,Rofi
  windowrule=float,pavucontrol

  windowrule=size 200,200,title:^(float_kitty)$
  windowrule=float,title:^(full_kitty)$
  windowrule=tile,title:^(kitty)$
  windowrule=float,title:^(fly_is_kitty)$



  windowrulev2 = float,class:^(google-chrome-beta)$,title:^(Save File)$
  windowrulev2 = float,class:^(google-chrome-beta)$,title:^(Open File)$
  windowrulev2 = float,class:^(google-chrome-beta)$,title:^(Picture-in-Picture)$
  windowrulev2 = float,class:^(blueman-manager)$
  windowrulev2 = float,class:^(org.twosheds.iwgtk)$
  windowrulev2 = float,class:^(blueberry.py)$
  windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
  windowrulev2 = float,class:^(geeqie)$
  windowrulev2 = tile,class:^(neovide)$

  # Increase the opacity 
  windowrule=opacity 0.92,thunar
  windowrule=opacity 0.96,discord
  windowrule=opacity 0.9,VSCodium
  windowrule=opacity 0.88,obsidian
  windowrule=opacity 0.7,neovide

  #w
  windowrule=opacity 1,neovim
  bindm=SUPER,mouse:272,movewindow
  bindm=SUPER,mouse:273,resizewindow

  xwayland bridge
  windowrulev2 = opacity 0.0 override 0.0 override,class:^(org.kde.xwaylandvideobridge)$
  windowrulev2 = noanim,class:^(xwaylandvideobridge)$
  windowrulev2 = nofocus,class:^(xwaylandvideobridge)$
  windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$

  ###########################################

  ██╗  ██╗███████╗██╗   ██╗    ██████╗ ██╗███╗   ██╗██████╗ ██╗███╗   ██╗ ██████╗ ███████╗
  ██║ ██╔╝██╔════╝╚██╗ ██╔╝    ██╔══██╗██║████╗  ██║██╔══██╗██║████╗  ██║██╔════╝ ██╔════╝
  █████╔╝ █████╗   ╚████╔╝     ██████╔╝██║██╔██╗ ██║██║  ██║██║██╔██╗ ██║██║  ███╗███████╗
  ██╔═██╗ ██╔══╝    ╚██╔╝      ██╔══██╗██║██║╚██╗██║██║  ██║██║██║╚██╗██║██║   ██║╚════██║
  ██║  ██╗███████╗   ██║       ██████╔╝██║██║ ╚████║██████╔╝██║██║ ╚████║╚██████╔╝███████║
  ╚═╝  ╚═╝╚══════╝   ╚═╝       ╚═════╝ ╚═╝╚═╝  ╚═══╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚══════╝
  ###########################################
  $mainMod = SUPER

  bind = $mainMod,RETURN, exec, kitty
  bind = $mainMod, Q, killactive, 
  bind = $mainMod, R, exec, rofi -show drun
  bind = $mainMod, E, exec, thunar
  bind = $mainMod, M, exit, 
  bind = $mainMod, T, togglefloating,
  bind = $mainMod, D, exec, tofi-drun --drun-launch=true
  bind = $mainMod, P, pseudo, # dwindle
  bind = $mainMod, G, togglesplit, # dwindle
  bind = $mainMod, S, togglegroup
  bind = $mainMod, F, fullscreen,1
  bind = $mainMod, F1, exec, ~/.config/hypr/keybind
  bind = $mainMod SHIFT,C,exec,bash ~/.config/hypr/scripts/hyprPicker.sh
  bind = $mainMod SHIFT, F, fullscreen,0
  bind = $mainMod, ESCAPE, exec, wlogout
  bind = $mainMod, SPACE, exec, /home/jusson/.config/hypr/lock.bash lock
  bind = ALTCTRL, DELETE, exec, htop
  # Screen recorder
  bind = $mainMod SHIFT, R, exec, wf-recorder
  # Emoji selector 
  bind = SHIFT $mainMod, E, exec, rofimoji --keybinding-copy ctrl+c
  bind = $mainMod, left, changegroupactive, b
  bind = $mainMod, right, changegroupactive, f
  bind = $mainMod, up, workspace, +1
  bind = $mainMod, down, workspace, -1
  bind = $mainMod SHIFT, s, moveintogroup, r
  # Move focus with mainMod + JKHL
  bind = $mainMod, J, movefocus, d
  bind = $mainMod, K, movefocus, u
  bind = $mainMod, H, movefocus, l
  bind = $mainMod, L, movefocus, r
  bind = $mainMod SHIFT, H, movewindoworgroup,l
  bind = $mainMod SHIFT, L, movewindoworgroup,r
  bind = $mainMod SHIFT, K, movewindoworgroup,u
  bind = $mainMod SHIFT, J, movewindoworgroup,d

  binde =, XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%+
  binde =, XF86AudioLowerVolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%-
  bind =, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
  bind =, XF86AudioPlay, exec, playerctl play-pause -i firefox
  binde =, XF86AudioNext, exec, playerctl next -i firefox
  binde =, XF86AudioPrev, exec, playerctl previous -i firefox
  bind =, XF86Explorer, exec, dolphin
  bind =, XF86HomePage, exec, firefox
  bind =, XF86Calculator, exec, speedcrunch
  bind =, XF86Tools, exec, spotify
  bind =, XF86AudioStop, exec, playerctl stop

  # Scroll through existing workspaces with mainMod + scroll
  bind = $mainMod, mouse_down, workspace, e+1
  bind = $mainMod, mouse_up, workspace, e-1

  # Move/resize windows with mainMod + LMB/RMB and dragging
  bindm = $mainMod, mouse:272, movewindow
  bindm = $mainMod, mouse:273, resizewindow
  bind = $mainMod SHIFT, left, resizeactive,-40 0
  bind = $mainMod SHIFT, right, resizeactive,40 0
  bind = $mainMod SHIFT, up, resizeactive,0 -40
  bind = $mainMod SHIFT, down, resizeactive,0 40
  bind = $mainMod SHIFT CTRL, 3, movecurrentworkspacetomonitor,DP-7
  bind = $mainMod SHIFT CTRL, 2, movecurrentworkspacetomonitor,DP-6
  bind = $mainMod SHIFT CTRL, 1, movecurrentworkspacetomonitor,eDP-1

  # Screen shot
  $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimshot --notify copy active; hyprctl keyword animation "fadeOut,1,4,default"
  bind = $mainMod, Print, exec, $screenshotarea
  bind = $mainMod SHIFT, Print ,exec, grimshot --notify save active
  bind = SHIFT, Print, exec, /home/jusson/.config/hypr/scripts/hyprshot -m region --clipboard-only
  bind = $mainMod, INSERT, exec, wl-paste -l

  bind = $mainMod SHIFT, RETURN, layoutmsg, swapwithmaster

  bind = $mainMod, 1, workspace, 1
  bind = $mainMod, 2, workspace, 2
  bind = $mainMod, 3, workspace, 3
  bind = $mainMod, 4, workspace, 4
  bind = $mainMod, 5, workspace, 5
  bind = $mainMod, 6, workspace, 6
  bind = $mainMod, 7, workspace, 7
  bind = $mainMod, 8, workspace, 8
  bind = $mainMod, 9, workspace, 9
  bind = $mainMod, 0, workspace, 10

  bind=$mainMod SHIFT,1,movetoworkspacesilent,1
  bind=$mainMod SHIFT,2,movetoworkspacesilent,2
  bind=$mainMod SHIFT,3,movetoworkspacesilent,3
  bind=$mainMod SHIFT,4,movetoworkspacesilent,4
  bind=$mainMod SHIFT,5,movetoworkspacesilent,5
  bind=$mainMod SHIFT,6,movetoworkspacesilent,6
  bind=$mainMod SHIFT,7,movetoworkspacesilent,7
  bind=$mainMod SHIFT,8,movetoworkspacesilent,8
  bind=$mainMod SHIFT,9,movetoworkspacesilent,9
  bind=$mainMod SHIFT,0,movetoworkspacesilent,10

  bindle=,XF86MonBrightnessUp,exec,brightnessctl set 10%+						#~/.config/hypr/scripts/brightness up  # increase screen brightness
  bindle=,XF86MonBrightnessDown,exec,brightnessctl set 10%-						#~/.config/hypr/scripts/brightness down # decrease screen brightnes

  exec-once=bash ~/.config/hypr/start.sh
''
