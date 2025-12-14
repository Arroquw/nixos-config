{ self, pkgs, user, lib, inputs, ... }: {
  users = {
    users.${user} = {
      extraGroups = [
        "networkmanager"
        "wheel"
        "qemu-libvirtd"
        "libvirtd"
        "kvm"
        "plugdev"
        "pipewire"
        "wireshark"
      ];
      packages = with pkgs; [
        (let
          pname = "prospect-mail";
          version = "0.5.4";
          src = pkgs.fetchurl {
            url =
              "https://github.com/julian-alarcon/prospect-mail/releases/download/v${version}/Prospect-Mail-${version}.AppImage";
            sha256 = "sha256-gG9y2FDhLcJLeROWgbpMse5tRoT0niAMiaQE5yQPhGg=";
          };
          appimageContents =
            pkgs.appimageTools.extractType1 { inherit pname version src; };
        in pkgs.appimageTools.wrapType1 {
          inherit pname version src;
          extraPkgs = appimageTools.defaultFhsEnvArgs.multiPkgs;
          extraInstallCommands = ''
            install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
            install -m 444 -D ${appimageContents}/${pname}.png $out/share/icons/hicolor/512x512/apps/${pname}.png
            substituteInPlace $out/share/applications/${pname}.desktop \
              --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname} %U'
          '';
        })
        (pkgs.makeDesktopItem {
          name = "realvnc";
          exec = "${lib.getExe' self.packages.${pkgs.system}.realvnc
            "realvnc-viewer"}";
          desktopName = "RealVNC";
          icon =
            "${pkgs.tokyonight-gtk-theme}/share/icons/Tokyonight-Light/apps/64/realvnc-vncviewer.svg";
        })
        wl-clipboard
        wlogout
        wayland-protocols
        wayland-utils
        rofimoji # Drawer + notifications
        jellyfin-ffmpeg # multimedia libs
        viewnior # image viewr
        speedcrunch
        vlc # Video player
        amberol # Music player
        wf-recorder # Video recorder
        sway-contrib.grimshot # Screenshot
        ffmpegthumbnailer # thumbnailer
        nordic
        xcur2png
        rubyPackages.glib2
        libcanberra-gtk3 # notification sound
        gtk4
        gtk3
        libadwaita
        gnome-system-monitor
        libnotify
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
        spotify
        ripgrep
        remmina
        libreoffice-qt
        hunspell
        hunspellDicts.nl_NL
        procps
        kdePackages.okular
        telegram-desktop
        imagemagick
        htop
        grim
        jq
        slurp
        cifs-utils
        pay-respects
        haruna
        nomacs
        self.packages.${pkgs.system}.hyprpicker-script
        self.packages.${pkgs.system}.hyprshot
        self.packages.${pkgs.system}.hyprkeybinds
        self.packages.${pkgs.system}.changewallpaper
        self.packages.${pkgs.system}.waybar-weather
        self.packages.${pkgs.system}.rofi-power-menu
        self.packages.${pkgs.system}.rofi-network-manager
        self.packages.${pkgs.system}.realvnc
        self.packages.${pkgs.system}.wayland-push-to-talk
        kdePackages.kcrash
        hyprlock
        hypridle
        wayvnc
        zip
        unzip
        gzip
        p7zip
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        gnome-text-editor
        home-manager
        gnome-font-viewer
        gnome-calculator
        peazip
        xarchiver
        wireshark
        file-roller
      ];
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "vscode" "spotify" ];

  security.pam.services.hyprlock.text = "auth include login";
  programs = {
    nix-ld.enable = true;
    nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      python311
      file-roller
    ];
    wireshark = {
      dumpcap.enable = true;
      enable = true;
    };
  };
  users.users.username = {
    isNormalUser = true;
    home = "/home/username";
    group = "no-internet";
  };
  users.groups.no-internet = {
    gid = 789;
    name = "no-internet";
  };
  virtualisation = {
    virtualbox.host.enable = true;
    vmware.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
  };
}
