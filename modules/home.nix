{ config, pkgs, self, user, lib, ... }:
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "${user}";
  home.homeDirectory = "/home/${user}";

  #Gtk 
    gtk = {
      enable = true;
      font.name = "TeX Gyre Adventor 10";
      theme = {
        name = "Juno";
        package = pkgs.juno-theme;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };

      gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

      gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    
  };

  #Hyprland
    home.sessionVariables = {
	    BROWSER = "firefox";
	    TERMINAL = "kitty";
	    NIXOS_OZONE_WL = "1";
	    QT_QPA_PLATFORMTHEME = "gtk3";
	    QT_SCALE_FACTOR = "1";
	    #MOZ_ENABLE_WAYLAND = "1";
	    SDL_VIDEODRIVER = "wayland";
	    _JAVA_AWT_WM_NONREPARENTING = "1";
	    QT_QPA_PLATFORM = "wayland-egl";
	    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
	    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
	    WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card";
	    #WLR_NO_HARDWARE_CURSORS = "1"; # if no cursor,uncomment this line  
	    # GBM_BACKEND = "nvidia-drm";
	    CLUTTER_BACKEND = "wayland";
	    WLR_RENDERER = "vulkan";
	    #__NV_PRIME_RENDER_OFFLOAD="1";
	    XDG_CURRENT_DESKTOP = "Hyprland";
	    XDG_SESSION_DESKTOP = "Hyprland";
	    XDG_SESSION_TYPE = "wayland";
	    GTK_USE_PORTAL = "1";
	    NIXOS_XDG_OPEN_USE_PORTAL = "1";
	    XDG_CACHE_HOME = "\${HOME}/.cache";
	    XDG_CONFIG_HOME = "\${HOME}/.config";
	    XDG_BIN_HOME = "\${HOME}/.local/bin";
	    XDG_DATA_HOME = "\${HOME}/.local/share";
    };


  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    package = pkgs.swayidle;
    timeouts = [
      {
        timeout = 5;
        command = "if ${pkgs.procps}/bin/pgrep -x swaylock; then ${pkgs.hyprland}/bin/hyprctl dispatch dpms off; fi";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
      {
        timeout = 300;
        command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      }
      {
        timeout = 360;
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
  };

  systemd.user.services.swayidle.Install.WantedBy = lib.mkForce ["hyprland-session.target"];
   programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;

      settings = {
        ignore-empty-password = true;
        font = "Liga SFMono Nerd Font";

        image = "~/Desktop/wallpapers/lockscreen/serey-morm-Z9G2Cm3n080-unsplash.jpg";

	indicator = true;
        indicator-radius = 100;
        indicator-thickness = 10;
        indicator-caps-lock = true;

	clock = true;
#        key-hl-color = "#8aadf4";
        key-hl-color = "#26942e";
        bs-hl-color = "#ed8796";
        caps-lock-key-hl-color = "#f5a97f";
        caps-lock-bs-hl-color = "#ed8796";

        separator-color = "#18261d";

        inside-color = "#243a27";
        inside-clear-color = "#227740";
        inside-caps-lock-color = "#243a27";
        inside-ver-color = "#243a27";
        inside-wrong-color = "#243a27";

        ring-color = "#1e3020";
        ring-clear-color = "#26942e";
        ring-caps-lock-color = "#231f20";
        ring-ver-color = "#1e2030";
        ring-wrong-color = "#ed8796";

        line-color = "#26942e";
        line-clear-color = "#26942e";
        line-caps-lock-color = "#f5a97f";
        line-ver-color = "#18261d";
        line-wrong-color = "#ed8796";

        text-color = "#26942e";
        text-clear-color = "#24273a";
        text-caps-lock-color = "#f5a97f";
        text-ver-color = "#24273a";
        text-wrong-color = "#24273a";

        debug = true;
      };
    };

}
