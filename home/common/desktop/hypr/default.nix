{ lib, self, config, pkgs, ... }: {

  home.packages = with pkgs; [ swww ];

  wayland.windowManager.hyprland = let
    modifiers = if config.home.username == "jusson" then
      "env = WLR_DRM_NO_MODIFIERS,1"
    else
      "";
  in {
    enable = true;
    xwayland.enable = true;

    settings = import ./config.nix { inherit config self pkgs lib; };
    extraConfig = ''
      windowrule=animation,1,4,overshot,slide,^(rofi)$
      windowrule=float,Rofi
      windowrule=float,pavucontrol

      windowrule=size 200,200,title:^(float_kitty)$
      windowrule=float,title:^(full_kitty)$
      windowrule=tile,title:^(kitty)$
      windowrule=float,title:^(fly_is_kitty)$

      env = WLR_DRM_NO_ATOMIC,1

      windowrulev2 = float,class:^(google-chrome-beta)$,title:^(Save File)$
      windowrulev2 = float,class:^(google-chrome-beta)$,title:^(Open File)$
      windowrulev2 = float,class:^(google-chrome-beta)$,title:^(Picture-in-Picture)$
      windowrulev2 = float,class:^(blueman-manager)$
      windowrulev2 = float,class:^(org.twosheds.iwgtk)$
      windowrulev2 = float,class:^(blueberry.py)$
      windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
      windowrulev2 = float,class:^(geeqie)$
      windowrulev2 = tile,class:^(neovide)$
      windowrulev2 = idleinhibit,fullscreen:1
      # Increase the opacity 
      windowrule=opacity 0.92,thunar
      windowrule=opacity 0.96,discord
      windowrule=opacity 0.9,VSCodium
      windowrule=opacity 0.88,obsidian
      windowrule=opacity 0.7,neovide

      #w
      windowrule=opacity 0.85,neovim
      bindm=SUPER,mouse:272,movewindow
      bindm=SUPER,mouse:273,resizewindow

      #xwayland bridge
      windowrulev2 = opacity 0.0 override 0.0 override,class:^(org.kde.xwaylandvideobridge)$
      windowrulev2 = noanim,class:^(xwaylandvideobridge)$
      windowrulev2 = nofocus,class:^(xwaylandvideobridge)$
      windowrulev2 = noinitialfocus,class:^(xwaylandvideobridge)$
      bind = ,mouse:276, pass, ^discord$
    '' + modifiers;
  };
}
