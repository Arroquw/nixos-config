{ self, pkgs, config, ... }: {
  imports = [ ../common.nix ];
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
        (pkgs.makeDesktopItem {
          name = "discord";
          exec =
            "env XDG_SESSION_TYPE=x11 env -u NIXOS_OZONE_WL ${pkgs.discord}/bin/discord --use-gl=desktop --enable-gpu-rasterization";
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
        (let
          pname = "citra";
          version = "608383e";
          src = pkgs.fetchurl {
            name = "citra-compressed-7z";
            url =
              "https://github.com/PabloMK7/citra/releases/download/r608383e/citra-linux-appimage-20240927-608383e.7z";
            sha256 = "sha256-kV0qz4yWyyMxRQwjjeloEljohhJQKjKv3XoBkfU24NU=";
            postFetch = ''
              cp $out src.7z
              ${pkgs.p7zip}/bin/7z -so e src.7z head/citra-qt.AppImage >$out
            '';
          };
        in pkgs.appimageTools.wrapType1 {
          inherit pname version src;
          name = "${pname}-${version}";
        })
        (discord.override { withOpenASAR = true; })
        self.packages.${pkgs.system}.krisp-patch
        self.packages.${pkgs.system}.dcpl2530dwlpr
        self.packages.${pkgs.system}.dcpl2530dwlpr-scan
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
        vmware-workstation
        microsoft-edge
      ];
    };
  };
  sops.secrets.password-justin = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  programs.adb.enable = true;
}
