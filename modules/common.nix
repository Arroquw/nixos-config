{ self, pkgs, user, ... }: {
  environment = { };
  users = {
    users.${user} = {
      extraGroups =
        [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" "plugdev" ];
      packages = with pkgs; [
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
        thefuck
        self.packages.${pkgs.system}.dcpl2530dwlpr
        self.packages.${pkgs.system}.dcpl2530dwlpr-scan
        self.packages.${pkgs.system}.sf100linux
        self.packages.${pkgs.system}.em100
        self.packages.${pkgs.system}.sway-idle-audio-inhibit
        self.packages.${pkgs.system}.realvnc
        stlink
        haruna
        nomacs
      ];
    };
  };
}
