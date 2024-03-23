# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/jusson
    ../common/optional/hyprland.nix
    ../common/optional/pipewire.nix
  ];
  arroquw = {
    desktop = {
      enable = true;
      hostname = "lnxclnt2840";
      gfxmodeEfi = "1920x1080";
    };
    nvidia.enable = false;
  };

  services = {
    xserver = {
      libinput = {
        enable = true;
        touchpad.tapping = true; # tap
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    keyutils
    minicom
    curl
    libusb1
  ];

  fileSystems."/mnt/pd-common/copydrive" = {
    device = "//prodrive.nl/copydrive/data";
    fsType = "cifs";
    options = [
      "rw,noauto,users,file_mode=0664,dir_mode=0775,noserverino,nohandlecache,credentials=/etc/win-credentials"
    ];
  };
  fileSystems."/mnt/pd-user/projects" = {
    device = "//prodrive.nl/product";
    fsType = "cifs";
    options = [
      "rw,noauto,users,file_mode=0664,dir_mode=0775,noserverino,nohandlecache,credentials=/etc/win-credentials"
    ];
  };
}
