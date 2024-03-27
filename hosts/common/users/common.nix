{ self, pkgs, user, lib, ... }: {
  users = {
    users.${user} = {
      extraGroups =
        [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" "plugdev" ];
      packages = with pkgs; [
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
        (pkgs.makeDesktopItem {
          name = "realvnc";
          exec = "${self.packages.${pkgs.system}.realvnc}/bin/realvnc-viewer";
          desktopName = "RealVNC";
          icon =
            "${pkgs.tokyonight-gtk-theme}/share/icons/Tokyonight-Light/apps/64/realvnc-vncviewer.svg";
        })
        wl-clipboard
        swaylock-effects
        wlogout
        wayland-protocols
        wayland-utils
        rofimoji # Drawer + notifications
        jellyfin-ffmpeg # multimedia libs
        viewnior # image viewr
        pavucontrol # Volume control
        gnome-text-editor
        gnome.file-roller
        gnome.gnome-font-viewer
        gnome.gnome-calculator
        speedcrunch
        vlc # Video player
        amberol # Music player
        wf-recorder # Video recorder
        sway-contrib.grimshot # Screenshot
        ffmpegthumbnailer # thumbnailer
        pamixer # mixer
        nordic
        xcur2png
        rubyPackages.glib2
        libcanberra-gtk3 # notification sound
        gnome.gnome-system-monitor
        libnotify
        poweralertd
        dbus
        xdg-utils
        xdg-launch
        wine64Packages.waylandFull
        wineWowPackages.stable
        wineWowPackages.staging
        winetricks
        wineWowPackages.waylandFull
        wine
        (wine.override { wineBuild = "wine64"; })
        curl
        pulseaudio
        spotify
        ripgrep
        remmina
        libreoffice-qt
        hunspell
        hunspellDicts.nl_NL
        procps
        okular
        telegram-desktop
        hyprpicker
        imagemagick
        htop
        grim
        jq
        slurp
        cifs-utils
        thefuck
        haruna
        nomacs
        self.packages.${pkgs.system}.xwaylandvideobridge
        self.packages.${pkgs.system}.hyprpicker-script
        self.packages.${pkgs.system}.hyprshot
        self.packages.${pkgs.system}.hyprkeybinds
        self.packages.${pkgs.system}.changewallpaper
        self.packages.${pkgs.system}.waybar-weather
        self.packages.${pkgs.system}.rofi-power-menu
        self.packages.${pkgs.system}.rofi-network-manager
        self.packages.${pkgs.system}.sway-idle-audio-inhibit
        self.packages.${pkgs.system}.realvnc
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "vscode" "spotify" ];
}
