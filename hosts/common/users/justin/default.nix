{ self, pkgs, config, ... }: {
  nixpkgs.config.allowUnfree = true;
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.justin = {
      isNormalUser = true;
      description = "Justin van Son";
      extraGroups = [ "networkmanager" "wheel" "plugdev" "kvm" ];
      hashedPasswordFile = config.sops.secrets.password-justin.path;
      packages = with pkgs; [
        vesktop
        (pkgs.makeDesktopItem {
          name = "discord";
          exec =
            "env -u NIXOS_OZONE_WL ${pkgs.discord}/bin/discord --use-gl=desktop";
          desktopName = "Discord";
          icon =
            "${pkgs.tela-circle-icon-theme}/share/icons/Tela-circle/scalable/apps/discord.svg";
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
        (discord.override { withOpenASAR = true; })
        self.packages.${pkgs.system}.krisp-patch
        pkgs.home-manager
        busybox
        procps
        coreutils
        blueman
        haruna
        nomacs
        hyprpicker
        imagemagick
        htop
        grim
        jq
        slurp
        cifs-utils
        okular
        telegram-desktop
        gnome.zenity
        wine64Packages.waylandFull
        wineWowPackages.stable
        wineWowPackages.staging
        winetricks
        wineWowPackages.waylandFull
        wine
        (wine.override { wineBuild = "wine64"; })
        curl
        pulseaudio
        tela-circle-icon-theme
        spotify
        ripgrep
        remmina
        libreoffice-qt
        hunspell
        hunspellDicts.nl_NL
        xdg-utils
        xdg-launch
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
        wlogout
        swaybg
        thefuck
        playerctl
        lutris
        wl-clipboard
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
        haruna
        nomacs
      ];
    };
  };
  sops.secrets.password-justin = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
  security.pam.services.swaylock.text = "auth include login";
}
