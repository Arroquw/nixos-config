{ config, pkgs, lib, user, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" ];
    packages = with pkgs; [
      neovim
      firefox
      swaylock-effects
      wlogout
      swaybg # Login etc..
      waybar # topbar
      wayland-protocols
      wayland-utils
      libsForQt5.qt5.qtwayland
      kanshi # laptop dncies
      rofi
      mako
      rofimoji # Drawer + notifications
      jellyfin-ffmpeg # multimedia libs
      viewnior # image viewr
      pavucontrol # Volume control
      xfce.thunar # filemanager
      xfce.xfconf
      gnome-text-editor
      gnome.file-roller
      gnome.gnome-font-viewer
      gnome.gnome-calculator
      speedcrunch
      vlc # Video player
      amberol # Music player
      cava # Sound Visualized
      wl-clipboard
      wf-recorder # Video recorder
      sway-contrib.grimshot # Screenshot
      ffmpegthumbnailer # thumbnailer
      playerctl # play,pause..
      pamixer # mixer
      brightnessctl # Brightness control
      ####GTK Customization####
      nordic
      papirus-icon-theme
      gtk3
      glib
      xcur2png
      rubyPackages.glib2
      libcanberra-gtk3 # notification sound
      #########System#########
      kitty
      gnome.gnome-system-monitor
      libnotify
      poweralertd
      dbus
      #gsettings-desktop-schemas
      #wrapGAppsHook
      #xdg-desktop-portal-hyprland
      ####photoshop dencies####
      gnome.zenity
      wine64Packages.waylandFull

      # support both 32- and 64-bit applications
      wineWowPackages.stable

      # wine-staging (version with experimental features)
      wineWowPackages.staging

      # winetricks (all versions)
      winetricks

      # native wayland support (unstable)
      wineWowPackages.waylandFull
      wine
      (wine.override { wineBuild = "wine64"; })
      curl
      (steam.override {
        extraPkgs = pkgs: [ bumblebee glxinfo mangohud gamescope libgdiplus ];
      }).run
      #########################
      pulseaudio
      primus
      bumblebee
      tela-circle-icon-theme
      (pkgs.makeDesktopItem {
        name = "discord";
        exec =
          "env -u NIXOS_OZONE_WL ${pkgs.discord}/bin/discord --use-gl=desktop";
        desktopName = "Discord";
        icon =
          "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
      })
      spotify
      feh
      swww
      ripgrep
      (pkgs.appimageTools.wrapType1 {
        name = "prospect-mail";
        src = pkgs.fetchurl {
          url =
            "https://github.com/julian-alarcon/prospect-mail/releases/download/v0.5.1/Prospect-Mail-0.5.1.AppImage";
          sha256 = "sha256-K106VkI/jPWnHqsWMWAKbzQyG5r0h+L3sufh4ZxkqIQ=";
        };
      })
      (pkgs.appimageTools.wrapType1 {
        name = "teams-for-linux";
        src = pkgs.fetchurl {
          url =
            "https://github.com/IsmaelMartinez/teams-for-linux/releases/download/v1.3.11/teams-for-linux-1.3.11.AppImage";
          sha256 = "sha256-UmVU5/oKuR3Wx2YHqD5cWjS/PeE7PTNJYF2VoGVdPcs=";
        };
      })
      (pkgs.appimageTools.wrapType1 {
        name = "arduino";
        src = pkgs.fetchurl {
          url =
            "https://downloads.arduino.cc/arduino-ide/nightly/arduino-ide_nightly-20231003_Linux_64bit.AppImage";
          sha256 = "sha256-E+UjKnykCm/yoYj8kixknlcS3TJCf2FuMh2RHYoh+L4=";
        };
        extraPkgs = pkgs: [ libsecret ];
      })
      remmina
      libreoffice-qt
      hunspell
      hunspellDicts.nl_NL
      openconnect
      xss-lock
      sshfs
      procps
      okular
      telegram-desktop
      grim
      jq
      slurp
      wireplumber
    ];
  };
  programs = {
    gamemode.enable = true;
    xss-lock.enable = true;
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    dconf.enable = lib.mkDefault true;
    #Steam
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  nixpkgs.config.allowUnfree = true;
  #swaylock pass verify
  #  security.pam.services.swaylock = {
  #    text = ''
  #      auth include login
  #    '';
  #  };

  #thunar dencies

  services.gvfs.enable = true;
  services.tumbler.enable = true;

  #gnome outside gnome

  security.pam.services.swaylock = { };
  #DIRS
  environment.etc."xdg/user-dirs.defaults".text = ''
    DESKTOP=$HOME/Desktop
    DOWNLOAD=$HOME/Downloads
    TEMPLATES=$HOME/Templates
    PUBLICSHARE=$HOME/Public
    DOCUMENTS=$HOME/Documents
    MUSIC=$HOME/Music
    PICTURES=$HOME/Photos
    VIDEOS=$HOME/Video
  '';

  #Overlays
  #Waybar wlr/Workspaces
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];
}
