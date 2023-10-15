{ self, pkgs, user, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = [ "networkmanager" "wheel" "qemu-libvirtd" "libvirtd" "kvm" ];
    packages = with pkgs; [
      (pkgs.appimageTools.wrapType1 {
        name = "arduino";
        src = pkgs.fetchurl {
          url =
            "https://downloads.arduino.cc/arduino-ide/nightly/arduino-ide_nightly-20231003_Linux_64bit.AppImage";
          sha256 = "sha256-E+UjKnykCm/yoYj8kixknlcS3TJCf2FuMh2RHYoh+L4=";
        };
        extraPkgs = pkgs: [ libsecret ];
      })
      wireplumber
      (discord.override { withOpenASAR = true; })
      self.packages.${pkgs.system}.krisp-patch
    ];
  };
  programs = {
    gamemode.enable = true;
    #Steam
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
