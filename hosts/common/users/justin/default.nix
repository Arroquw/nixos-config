{ self, pkgs, config, ... }: {
  imports = [ ../common.nix ];
  nixpkgs.config.allowUnfree = true;
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.justin = {
      isNormalUser = true;
      description = "Justin van Son";
      extraGroups = [ "networkmanager" "wheel" "plugdev" "kvm" "input" ];
      hashedPasswordFile = config.sops.secrets.password-justin.path;
      packages = with pkgs; [
        (pkgs.makeDesktopItem {
          name = "discord";
          exec =
            "${pkgs.discord}/bin/discord --use-gl=desktop --enable-gpu-rasterization --enable-features=UseOzonePlatform --ozone-platform=wayland";
          desktopName = "Discord";
          icon =
            "${pkgs.xfce.xfce4-icon-theme}/share/icons/apps/scalable/discord.svg";
        })
        discord
        (pkgs.appimageTools.wrapType1 (let
          pname = "arduino-ide";
          version = "2.3.4";
        in {
          inherit pname version;
          src = pkgs.fetchurl {
            url =
              "https://downloads.arduino.cc/arduino-ide/${pname}_${version}_Linux_64bit.AppImage";
            sha256 = "sha256-PyW3fJPEQmo0+ZYi/HubW8J66KeAnoN2RhYr9Yu2WU8=";
          };
          extraPkgs = pkgs: [ libsecret ];
        }))
        (let
          pname = "citra";
          version = "608383e";
          src = pkgs.fetchurl {
            name = "citra-compressed-7z";
            url =
              "https://github.com/PabloMK7/citra/releases/download/r608383e/${pname}-linux-appimage-20240927-${version}.7z";
            sha256 = "sha256-yzEznDwDlODszxHKi131FfP4nT6GBaPEtMHBD+0SWyk=";
            postFetch = ''
              cp $out src.7z
              ${pkgs.p7zip}/bin/7z -so e src.7z head/citra-qt.AppImage >$out
            '';
          };
        in pkgs.appimageTools.wrapType1 { inherit pname version src; })
        self.packages.${pkgs.system}.krisp-patch
        self.packages.${pkgs.system}.dcpl2530dwlpr
        self.packages.${pkgs.system}.dcpl2530dwlpr-scan
        self.packages.${pkgs.system}.easyeda-pro
        droidcam
        lutris
        v4l-utils
        samba
        dosbox
        winetricks
        wine-staging
        bottles
        nodejs
        procps
        gcc
        mesa
        gtk3
        xdotool
        xorg.xwininfo
        vesktop
        kdePackages.plasma-workspace
        microsoft-edge
        clang-tools
        bear
        gcc-arm-embedded
        glibc_multi
        stm32cubemx
        (pkgs.makeDesktopItem {
          name = "microsoft-edge-wl";
          exec =
            "${pkgs.microsoft-edge}/bin/microsoft-edge --enable-features=UseOzonePlatform --ozone-platform=wayland --use-gl=desktop";
          desktopName = "microsoft-edge-wayland";
        })
      ];
    };
  };
  sops.secrets.password-justin = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  programs.adb.enable = true;
}
