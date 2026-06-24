{
  config,
  self,
  pkgs,
  lib,
  ...
}:
let
  touchpad_users = [ "jusson" ];
  touchpad = {
    disable_while_typing = 1;
    natural_scroll = 1;
    clickfinger_behavior = 1;
    middle_button_emulation = 1;
    tap-to-click = 1;
  };
  hyprshutdown = lib.getExe pkgs.hyprshutdown;
  runapp = lib.getExe pkgs.runapp;
  mainmod = "SUPER";
  mkRaw = lib.generators.mkLuaInline;
  mkRawLong =
    string: mkRaw (lib.strings.replaceStrings [ "\n" "\r" "\t" "  " ] [ "" "" "" "" ] string);
  bind = args: { _args = args; };
  bindl = args: bind (args ++ [ { locked = true; } ]);
  bindr = args: bind (args ++ [ { release = true; } ]);
  bindel =
    args:
    bind (
      args
      ++ [
        {
          locked = true;
          repeat = true;
        }
      ]
    );
  bindm = args: bind (args ++ [ { mouse = true; } ]);

  keys = keys: lib.concatStringsSep " + " keys;
  mkeys = akeys: keys ([ mainmod ] ++ akeys);
  mkey = key: mkeys [ key ];

  exec = cmd: mkRaw "hl.dsp.exec_cmd(\"${cmd}\")";
  rexec = cmd: exec "${runapp} ${cmd}";
in
{
  config.input = {
    repeat_rate = 50;
    repeat_delay = 240;
    kb_layout = "us";
    kb_variant = "altgr-intl";
    kb_options = "compose:ralt";
    follow_mouse = 1;
    sensitivity = 0;
  }
  // (
    if builtins.elem "${config.home.username}" touchpad_users then
      {
        inherit touchpad;
      }
    else
      { }
  );

  config.gestures =
    if builtins.elem "${config.home.username}" touchpad_users then [ "3, swipe, workspace" ] else [ ];

  config.general = {
    layout = "dwindle";
    gaps_in = 1;
    gaps_out = 1;
    border_size = 2;
    "col.active_border" = "rgba(5e81acff)"; # 5e81ac ff
    "col.inactive_border" = "rgba(33333366)"; # 333333 66
    allow_tearing = true;
  };

  config.group = rec {
    insert_after_current = true;
    groupbar = {
      height = 10;
      scrolling = false;
      stacked = 1;
      text_color = "rgb(000000)";
      "col.active" = "rgba(2a4fc05e)"; # #2a4fc0 - these 4 are gradients so they blend in with the wallpaper
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

  config.decoration = {
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

  config.animations = {
    enabled = true;
  };

  curve =
    let
      curve =
        { name, ... }@args:
        {
          _args = [
            name
            (lib.attrsets.removeAttrs args [ "name" ])
          ];
        };
      bezier =
        { name, points }:
        (curve {
          inherit name points;
          type = "bezier";
        });
    in
    [
      (bezier {
        name = "overshot";
        points = [
          [
            0.28
            0.99
          ]
          [
            0.29
            1.01
          ]
        ];
      })
    ];

  animation = [
    {
      leaf = "windows";
      enabled = true;
      speed = 4;
      bezier = "overshot";
      style = "slide";
    }
    {
      leaf = "windowsIn";
      enabled = true;
      speed = 8;
      bezier = "default";
      style = "popin 80%";
    }
    {
      leaf = "fadeIn";
      enabled = true;
      speed = 10;
      bezier = "default";
    }
    {
      leaf = "workspaces";
      enabled = true;
      speed = 5.1;
      bezier = "overshot";
      style = "slide";
    }
    {
      leaf = "border";
      enabled = true;
      bezier = "default";
      speed = 14;
    }
  ];

  config.dwindle = {
    force_split = 0;
  };

  config.master = {
    new_on_top = true;
  };

  config.render = {
    direct_scanout = 1;
  };

  config.misc = {
    disable_hyprland_logo = true;
    disable_splash_rendering = true;
    key_press_enables_dpms = true;
    mouse_move_enables_dpms = if "${config.home.username}" != "justin" then true else false;
    allow_session_lock_restore = true;
  };

  config.cursor = {
    sync_gsettings_theme = true;
    hide_on_key_press = true;
    no_hardware_cursors = 1;
    no_break_fs_vrr = 2;
    min_refresh_rate = 60;
    use_cpu_buffer = 2;
  };

  layer_rule = {
    match = {
      namespace = "waybar";
    };
    blur = true;
  };

  on._args =
    let
      wallpaper-script = "${lib.getExe' self.packages.${pkgs.system}.changewallpaper "changewallpaper"}";
      gecko = lib.optionals (config.home.username == "justin") [
        "gtk-launch steam"
        "gtk-launch discord"
        "${
          lib.getExe' self.packages.${pkgs.system}.wayland-push-to-talk "push-to-talk"
        } -v -k BTN_EXTRA -n Pause /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse"
        "${
          lib.getExe' self.packages.${pkgs.system}.wayland-push-to-talk "push-to-talk"
        } -v -k KEY_PAUSE -n Pause /dev/input/by-id/usb-SONiX_USB_DEVICE-event-kbd"
      ];
      programs = [
        "${lib.getExe' pkgs.poweralertd "poweralertd"}"
        "${wallpaper-script}"
        "${lib.getExe' pkgs.blueman "blueman-applet"}"
      ]
      ++ gecko;
      tabbed = map (s: "\thl.exec_cmd(\"${s}\")") programs;
      lines = lib.concatStringsSep "\n" tabbed;
      func = mkRaw ''
        function()
          ${lines}
        end'';
    in
    [
      "hyprland.start"
      func
    ];

  bind =
    let
      playerctl = "${lib.getExe' pkgs.playerctl "playerctl"}";
      terminal = "${lib.getExe' pkgs.kitty "kitty"}";
      rofi = "${lib.getExe' pkgs.rofi "rofi"}";
      thunar = "${lib.getExe' pkgs.thunar "thunar"}";
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
      lock = "${lib.getExe' pkgs.procps "pgrep"} hyprlock || ${lib.getExe' pkgs.systemd "loginctl"} lock-session";
      keybind = "${self.packages.${pkgs.system}.hyprkeybinds}/bin/hyprkeybinds";
      hyprpicker = "${self.packages.${pkgs.system}.hyprpicker-script}/bin/hyprpicker-script";
      resolution-script = "${self.packages.${pkgs.system}.hypr-resolution}/bin/hypr-resolution";
      hyprshot = "${self.packages.${pkgs.system}.hyprshot}/bin/hyprshot";
      discordPtt = lib.optionals (config.home.username == "justin") [
        (bindm [
          (keys [ "mouse:276" ])
          (mkRaw ''hl.dsp.pass({window = "class:^(discord)$"})'')
        ])
      ];
    in
    [
      (bind [
        (mkey "return")
        (exec "${terminal}")
      ])
      (bind [
        (mkey "Q")
        (mkRaw "hl.dsp.window.close()")
      ])
      (bind [
        (mkey "R")
        (exec "${rofi} -show drun")
      ])
      (bind [
        (mkey "E")
        (rexec "${thunar}")
      ])
      (bind [
        (mkey "M")
        (exec hyprshutdown)
      ])
      (bind [
        (mkey "F1")
        (exec "${keybind}")
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "C"
        ])
        (exec "${hyprpicker}")
      ])
      (bind [
        (mkeys [
          "CTRL"
          "P"
        ])
        (exec "sh -c 'hyprprop >> /tmp/hyprprop.log'")
      ])
      (bind [
        (mkey "ESCAPE")
        (exec "${wlogout}")
      ])
      (bind [
        (mkey "SPACE")
        (exec "${lock}")
      ])
      (bind [
        (keys [
          "ALT"
          "CTRL"
          "DELETE"
        ])
        (rexec "${htop}")
      ])
      (bind [
        (mkey "T")
        (mkRaw ''hl.dsp.window.float({ action = "toggle" })'')
      ])
      (bind [
        (mkey "G")
        (mkRaw ''hl.dsp.layout("togglesplit")'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "P"
        ])
        (mkRaw "hl.dsp.window.pseudo()")
      ])
      (bind [
        (mkey "P")
        (exec "${resolution-script}")
      ])
      (bind [
        (mkey "F")
        (mkRaw ''hl.dsp.window.fullscreen({mode = "maximized", action = "toggle" })'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "F"
        ])
        (mkRaw ''hl.dsp.window.fullscreen({mode = "fullscreen", action = "toggle" })'')
      ])
      (bind [
        (mkey "S")
        (mkRaw "hl.dsp.group.toggle()")
      ])
      (bind [
        (mkey "up")
        (mkRaw "hl.dsp.group.next()")
      ])
      (bind [
        (mkey "down")
        (mkRaw "hl.dsp.group.prev()")
      ])
      (bind [
        (mkey "right")
        (mkRaw ''hl.dsp.focus({workspace = "+1"})'')
      ])
      (bind [
        (mkey "left")
        (mkRaw ''hl.dsp.focus({workspace = "-1"})'')
      ])
      (bind [
        (mkey "J")
        (mkRaw ''hl.dsp.focus({direction = "d"})'')
      ])
      (bind [
        (mkey "K")
        (mkRaw ''hl.dsp.focus({direction = "u"})'')
      ])
      (bind [
        (mkey "H")
        (mkRaw ''hl.dsp.focus({direction = "l"})'')
      ])
      (bind [
        (mkey "L")
        (mkRaw ''hl.dsp.focus({direction = "r"})'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "S"
        ])
        (mkRaw ''hl.dsp.window.move({into_group = "r"})'')
      ])
      (bind [
        (mkeys [
          "CTRL"
          "J"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "l", group_aware = "true"})'')
      ])
      (bind [
        (mkeys [
          "CTRL"
          "K"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "r", group_aware = "true"})'')
      ])
      (bind [
        (mkeys [
          "CTRL"
          "H"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "u", group_aware = "true"})'')
      ])
      (bind [
        (mkeys [
          "CTRL"
          "L"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "d", group_aware = "true"})'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "J"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "l", group_aware = "false"})'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "K"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "r", group_aware = "false"})'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "H"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "u", group_aware = "false"})'')
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "L"
        ])
        (mkRaw ''hl.dsp.window.move({direction = "d", group_aware = "false"})'')
      ])
      (bindm [
        (mkey "mouse_down")
        (mkRaw ''hl.dsp.window.move({workspace = "e+1"})'')
      ])
      (bindm [
        (mkey "mouse_down")
        (mkRaw ''hl.dsp.window.move({workspace = "e-1"})'')
      ])
      (bind [
        (keys [ "XF86AudioMute" ])
        (exec "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle")
      ])
      (bind [
        (keys [ "XF86AudioPlay" ])
        (exec "${playerctl} play-pause -i firefox")
      ])
      (bind [
        (keys [ "XF86AudioStop" ])
        (exec "${playerctl} stop")
      ])
      (bind [
        (keys [ "XF86Explorer" ])
        (rexec "thunar")
      ])
      (bind [
        (keys [ "XF86HomePage" ])
        (exec "${browser}")
      ])
      (bind [
        (keys [ "XF86Calculator" ])
        (rexec "${speedcrunch}")
      ])
      (bind [
        (keys [ "XF86Tools" ])
        (rexec "${spotify}")
      ])
      (bind [
        (mkeys [
          "ALT"
          "PRINT"
        ])
        (exec "${hyprshot} -m active -m output")
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "PRINT"
        ])
        (exec "${hyprshot} -zm region")
      ])
      (bind [
        (mkey "Print")
        (exec " ${hyprshot} -m active -m window")
      ])
      (bind [
        (keys [
          "ALT"
          "SHIFT"
          "Print"
        ])
        (exec "${hyprshot} -m active -m output --clipboard-only")
      ])
      (bind [
        (keys [
          "CTRL"
          "SHIFT"
          "Print"
        ])
        (exec "${hyprshot} -m active -m window --clipboard-only")
      ])
      (bind [
        (keys [
          "SHIFT"
          "Print"
        ])
        (exec "${hyprshot} -zm region --clipboard-only")
      ])
      (bind [
        (mkeys [
          "SHIFT"
          "RETURN"
        ])
        (mkRaw ''hl.dsp.layout("swapwithmaster")'')
      ])
    ]
    ++ lib.flatten (
      (map (
        n:
        let
          mod = a: b: a - (b * (a / b));
          key = toString (mod n 10);
          ws = toString n;
        in
        [
          (bind [
            (mkey key)
            (mkRaw ''hl.dsp.focus({workspace = "${ws}"})'')
          ])
          (bind [
            (mkeys [
              "SHIFT"
              key
            ])
            (mkRaw ''hl.dsp.window.move({workspace = "${ws}"})'')
          ])
        ]
      ) (lib.range 1 10))
    )
    ++ discordPtt
    ++ [
      (bindm [
        (mkey "mouse:272")
        (mkRaw "hl.dsp.window.drag()")
      ])
      (bindm [
        (mkey "mouse:273")
        (mkRaw "hl.dsp.window.resize()")
      ])
    ]
    ++ (
      let
        wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";
        playerctl = "${lib.getExe' pkgs.playerctl "playerctl"}";
        brightnessctl = "${lib.getExe' pkgs.brightnessctl "brightnessctl"}";
      in
      [
        (bindr [
          (mkeys [
            "SHIFT"
            "left"
          ])
          (mkRaw ''hl.dsp.window.resize({x = "-40", y = "0", relative = "true"})'')
        ])
        (bindr [
          (mkeys [
            "SHIFT"
            "right"
          ])
          (mkRaw ''hl.dsp.window.resize({x = "40", y = "0", relative = "true"})'')
        ])
        (bindr [
          (mkeys [
            "SHIFT"
            "up"
          ])
          (mkRaw ''hl.dsp.window.resize({x = "0", y = "-40", relative = "true"})'')
        ])
        (bindr [
          (mkeys [
            "SHIFT"
            "down"
          ])
          (mkRaw ''hl.dsp.window.resize({x = "0", y = "40", relative = "true"})'')
        ])
        (bindr [
          (keys [ "XF86AudioRaiseVolume" ])
          (exec "${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%+")
        ])
        (bindr [
          (keys [ "XF86AudioLowerVolume" ])
          (exec "${wpctl} set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 2%-")
        ])
        (bindr [
          (keys [ "XF86AudioNext" ])
          (exec "${playerctl} next -i firefox")
        ])
        (bindr [
          (keys [ "XF86AudioPrev" ])
          (exec "${playerctl} previous -i firefox")
        ])
        (bindr [
          (keys [ "XF86MonBrightnessUp" ])
          (exec "${brightnessctl} set 10%+")
        ])
        (bindr [
          (keys [ "XF86MonBrightnessDown" ])
          (exec "${brightnessctl} set 10%-")
        ])
      ]
    );

  # Map the monitors set to hyprland config strings. Uses monitor description by default if set, otherwise name (e.g. DP-2)
  monitor = map (
    m:
    let
      resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
      position = "${toString m.x}x${toString m.y}";
      monitorString = if m.desc != null then "desc:${m.desc}" else "${m.name}";
    in
    if m.enabled then
      mkRawLong ''
        {
                disabled = false,
                output = "${monitorString}",
                mode = "${resolution}",
                position = "${position}",
                scale = "${lib.toString m.scale}",
                vrr = ${lib.toString m.vrr},
              }''
    else
      mkRawLong ''
        {
                disabled = true,
                output = "${monitorString}",
              }''
  ) config.monitors;

  #  workspace as string instead of list: (only allows one workspace per monitor to be specified)
  #  workspace = map (m:
  #    let monitorString = if m.name == null then "desc:${m.desc}" else "${m.name}";
  #    in "${m.workspace},monitor:${monitorString}")
  #    (lib.filter (m: m.enabled && m.workspace != null) config.monitors);

  # Gotta concat to take the double list into account
  workspace_rule =
    builtins.concatMap (
      m:
      let
        monitorString = if m.desc != null then "desc:${m.desc}" else "${m.name}";
      in
      map (w: mkRaw "{ workspace = ${w}, monitor = \"${monitorString}\", default = true }") m.workspace
    ) (lib.filter (m: m.enabled && m.workspace != null) config.monitors)
    ++ [
      (mkRaw "{workspace = \"w[t1]\", gaps_out = 0, gaps_in = 0}")
      (mkRaw "{workspace = \"w[tg1]\", gaps_out = 0, gaps_in = 0}")
      (mkRaw "{workspace = \"f[1]\", gaps_out = 0, gaps_in = 0}")
    ];

  window_rule =
    let
      gecko = lib.optionals (config.home.username == "justin") [
        {
          match.class = "discord";
          opacity = "0.96";
          workspace = "5 silent";
        }
        {
          match.class = "steam";
          workspace = "5 silent";
        }
        {
          match.title = "Alt1 Lite app";
          tag = "+alt1app";
        }
        {
          match.tag = "alt1app";
          no_max_size = true;
          float = true;
          no_blur = true;
          no_initial_focus = true;
          border_size = 0;
          immediate = true;
          allows_input = true;
        }
        {
          match.title = "Alt1Lite overlay window";
          tag = "+alt1overlay";
        }
        {
          match.tag = "alt1overlay";
          pin = true;
          no_focus = true;
          no_initial_focus = true;
          no_follow_mouse = true;
          no_blur = true;
          border_size = 0;
          fullscreen_state = "-1 2";
          float = true;
          size = [
            2560
            1390
          ];
          persistent_size = true;
          suppress_event = "activate activatefocus fullscreen";
          render_unfocused = true;
          workspace = 1;
        }
        {
          match.class = "rs2client.exe";
          tile = true;
          workspace = 1;
          idle_inhibit = "always";
        }
        {
          match.tag = "alt1";
          workspace = 1;
        }
        {
          match.class = "jagexlauncher.exe";
          workspace = 3;
        }
        {
          match.class = "runescape.exe";
          render_unfocused = true;
        }
        {
          match = {
            title = "GeForce NOW.*";
            class = "msedge-.*";
          };
          fullscreen_state = "-1 2";
          no_shortcuts_inhibit = true;
          suppress_event = "fullscreen";
        }
        {
          match.title = "Heroes of the Storm";
          suppress_event = "fullscreen";
          fullscreen_state = "-1 2";
          workspace = 1;
        }
        {
          match.title = "Factorio";
          content = "game";
        }
      ];
    in
    [
      {
        match.class = "rofi";
        float = true;
      }
      {
        match.class = "org.pulseaudio.pavucontrol";
        float = true;
      }
      {
        match.title = "float_kitty";
        size = [
          200
          200
        ];
        float = true;
      }
      {
        match.title = "full_kitty";
        float = true;
      }
      {
        match.title = "kitty";
        tile = true;
      }
      {
        match.title = "fly_is_kitty";
        float = true;
      }
      {
        match.class = "thunar";
        opacity = 0.92;
      }
      {
        match.class = "obsidian";
        opacity = 0.88;
      }
      {
        match.class = "neovim";
        opacity = 0.85;
      }
      {
        match.class = "blueman-manager";
        float = true;
      }
      {
        match.class = "org.twosheds.iwgtk";
        float = true;
      }
      {
        match.class = "blueberry.py";
        float = true;
      }
      {
        match.class = "xdg-desktop-portal-gtk";
        float = true;
      }
      {
        match = {
          float = false;
          workspace = "w[t1]";
        };
        border_size = 0;
        rounding = 0;
      }
      {
        match = {
          float = false;
          workspace = "w[tg1]";
        };
        border_size = 0;
        rounding = 0;
      }
      {
        match = {
          float = false;
          workspace = "f[1]";
        };
        border_size = 0;
        rounding = 0;
      }
    ]
    ++ gecko;

}
