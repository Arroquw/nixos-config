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
      ];
    };
  };
  sops.secrets.password-justin = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
  security.pam.services.swaylock.text = "auth include login";
}
