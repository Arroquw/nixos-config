{
  config,
  self,
  pkgs,
  ...
}:
{
  home.packages =
    with pkgs;
    [

      # Wayland session tooling
      wl-clipboard
      wlogout
      wayland-protocols
      wayland-utils
      wf-recorder
      wayvnc
      libcanberra-gtk3
      libnotify
      dbus
      xdg-utils
      xdg-launch

      # Wine. This replaces six overlapping builds that used to live in
      # users.users.<name>.packages; they only coexisted because that profile
      # sets ignoreCollisions (they all ship bin/winecfg). The wow64 build
      # handles 32- and 64-bit through a single `wine` binary.
      wineWow64Packages.staging
      winetricks

      # Media
      jellyfin-ffmpeg
      spotify
      haruna
      nomacs

      # Documents / office
      libreoffice-qt
      hunspell
      hunspellDicts.nl_NL
      kdePackages.okular

      # Archives
      zip
      unzip
      gzip
      p7zip
      xarchiver
      file-roller

      # GNOME utilities
      gnome-text-editor
      gnome-font-viewer
      gnome-calculator
      gnome-system-monitor
      gnome-keyring
      kdePackages.kcrash

      # CLI / misc
      htop
      jq
      cifs-utils
      pay-respects
      remmina
      telegram-desktop
    ]
    ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      hyprpicker-script
      hyprshot
      (hyprkeybinds.override { noctalia = config.programs.noctalia.package; })
      changewallpaper
      wayland-push-to-talk
    ]);
}
