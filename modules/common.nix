{ self, config, pkgs, lib, user, ... }: {
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
      xdg-utils
      xdg-launch
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
      #########################
      pulseaudio
      tela-circle-icon-theme
      spotify
      ripgrep
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
      home-manager
      dunst
      hyprpicker
      imagemagick
      htop
      grim
      jq
      slurp
      cifs-utils
      (let
        pname = "prospect-mail";
        version = "0.5.1";
        name = "${pname}-${version}";
        src = pkgs.fetchurl {
          url =
            "https://github.com/julian-alarcon/prospect-mail/releases/download/v${version}/Prospect-Mail-${version}.AppImage";
          sha256 = "sha256-K106VkI/jPWnHqsWMWAKbzQyG5r0h+L3sufh4ZxkqIQ=";
        };
        appimageContents =
          pkgs.appimageTools.extractType1 { inherit name src; };
      in pkgs.appimageTools.wrapType1 {
        inherit name src;
        extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
        extraInstallCommands = ''
          		mv $out/bin/${name} $out/bin/${pname}
          		install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
          		install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
          		substituteInPlace $out/share/applications/${pname}.desktop \
              	--replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
          	'';
      })
      self.packages.${pkgs.system}.xwaylandvideobridge
      self.packages.${pkgs.system}.hyprpicker-script
      self.packages.${pkgs.system}.hyprshot
      self.packages.${pkgs.system}.hyprkeybinds
      self.packages.${pkgs.system}.changewallpaper
      self.packages.${pkgs.system}.waybar-weather
      self.packages.${pkgs.system}.rofi-power-menu
      self.packages.${pkgs.system}.rofi-network-manager
    ];
  };

  nixpkgs.config.allowUnfree = true;
  programs = {
    xss-lock.enable = true;

    #thunar dencies
    thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    dconf.enable = lib.mkDefault true;
  };
  services = {
    gvfs.enable = true;
    tumbler.enable = true;
  };

  #gnome outside gnome
  systemd.user.extraConfig = ''
    DefaultEnvironment="PATH=/run/wrappers/bin:/home/jusson/.nix-profile/bin:/home/jusson/.local/state/nix/profile/bin:/etc/profiles/per-user/jusson/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
  '';

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
