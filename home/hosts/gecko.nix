{
  config,
  self,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../common/global.nix
    ../common/packages.nix
    ../common/desktop
    ../common/programs
    ../common/programs/games
  ];

  home = {
    username = "justin";

    packages =
      with pkgs;
      [
        (pkgs.appimageTools.wrapType1 (
          let
            pname = "arduino-ide";
            version = "2.3.4";
          in
          {
            inherit pname version;
            src = pkgs.fetchurl {
              url = "https://downloads.arduino.cc/arduino-ide/${pname}_${version}_Linux_64bit.AppImage";
              sha256 = "sha256-PyW3fJPEQmo0+ZYi/HubW8J66KeAnoN2RhYr9Yu2WU8=";
            };
            extraPkgs = pkgs: [ libsecret ];
          }
        ))
        (pkgs.appimageTools.wrapType2 rec {
          name = "BambuStudio";
          pname = "bambu-studio";
          version = "02.07.01.62";
          ubuntu_version = "24.04";

          src = pkgs.fetchurl {
            url = "https://github.com/bambulab/BambuStudio/releases/download/v${version}/BambuStudio_ubuntu${ubuntu_version}-v${version}-20260616195227.AppImage";
            sha256 = "sha256-+pi2CFMt+7uysJMUg6rEHlf7GcF1osx719Uo1eD7soc=";
          };

          profile = ''
            export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
            export GIO_MODULE_DIR="${pkgs.glib-networking}/lib/gio/modules/"
          '';

          extraPkgs =
            pkgs: with pkgs; [
              cacert
              glib
              glib-networking
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              webkitgtk_4_1
            ];
        })
        (
          let
            pname = "azahar";
            version = "2122.1";
            src = pkgs.fetchurl {
              name = "azahar";
              url = "https://github.com/azahar-emu/azahar/releases/download/${version}/azahar.AppImage";
              sha256 = "sha256-x90f43LNxS/TSFtEs7j/luYFkHwC59lKhROqv68V0YE=";
            };
          in
          pkgs.appimageTools.wrapType1 { inherit pname version src; }
        )
        (pkgs.makeDesktopItem {
          name = "microsoft-edge-wl";
          exec = "${lib.getExe' config.programs.microsoft-edge.finalPackage "microsoft-edge"} --ozone-platform=wayland --use-gl=desktop";
          desktopName = "microsoft-edge-wayland";
        })

        # Gaming
        (lutris.override (_: {
          extraPkgs = pkgs: [
            pkgs.wineWow64Packages.stagingFull
            pkgs.winetricks
            pkgs.libappindicator-gtk2
            pkgs.libappindicator-gtk3
            pkgs.appindicator-sharp
            pkgs.mangohud
          ];
        }))
        gamescope-wsi
        mangohud

        # Virtualisation
        virt-viewer
        libvirt-glib
        looking-glass-client
        (scream.override (_: {
          pcapSupport = true;
        }))
        virtiofsd
        OVMFFull

        # Development / hardware
        bear
        nodejs

        # Desktop / misc
        # NB: libappindicator-gtk2/-gtk3 are not listed here -- they ship the
        # same AppIndicator3 typelib and collide. Lutris already receives both
        # through its own extraPkgs above, which is where they're actually used.
        v4l-utils
        xdotool
        xwininfo
      ]
      ++ (with self.packages.${pkgs.stdenv.hostPlatform.system}; [
        dcpl2530dwlpr
        dcpl2530dwlpr-scan
        easyeda-pro
      ]);

    file = {
      ".config/citra-emu/sdl2-config.ini".source = ../../scripts/sdl2-config.ini;
    };
  };

  programs = {
    # settings replaces a hand-written ~/.config/discord/settings.json
    # that used to live in home/common/global.nix.
    discord = {
      enable = true;
      settings.SKIP_HOST_UPDATE = true;
    };

    # Wayland flags come from NIXOS_OZONE_WL for the normal launcher;
    # the microsoft-edge-wl desktop item above forces them explicitly.
    microsoft-edge.enable = true;
  };

  monitors = [
    {
      name = "DP-4";
      desc = "Dell Inc. DELL U2719D CK3WTS2";
      width = 2560;
      height = 1440;
      workspace = [
        "2"
        "5"
      ];
    }
    {
      name = "DP-5";
      desc = "Microstep MAG274QRF-QD CA8A270B00307";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      x = 2560;
      primary = true;
      vrr = 3;
    }
    {
      name = "Unknown-1";
      enabled = false;
    }
  ];
}
