_: ''

  env = WLR_NO_HARDWARE_CURSORS,1
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
''
