{ self, pkgs, user, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" ];
    packages = with pkgs; [
      mangohud
      gamescope
      bumblebee
      glxinfo
      primus
      (steam.override {
        extraPkgs = pkgs: [
          bumblebee
          glxinfo
          mangohud
          gamescope
          libgdiplus
          primus
        ];
      }).run
      #########################
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
  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;

}
