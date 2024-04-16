# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, lib, ... }: {
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

  environment.etc."request-key.conf" = {
    source = lib.mkForce (pkgs.writeText "request-key.conf" ''
      create id_resolver * * /nix/store/4mgp5ybsvnhh11082gf5gix22dq8xwnv-nfs-utils-2.6.2/bin/nfsidmap -t 600 %k %d
      create dns_resolver * * /run/current-system/sw/bin/key.dns_resolver %k
    '');
  };

  fileSystems = {
    "/mnt/pd-common/copydrive" = {
      device = "//prodrive.nl/copydrive/data";
      fsType = "cifs";
      options = [
        "rw,noauto,users,file_mode=0664,dir_mode=0775,noserverino,nohandlecache,noperm,uid=1000,credentials=/etc/win-credentials"
      ];
    };
    "/mnt/pd-user/projects" = {
      device = "//prodrive.nl/product";
      fsType = "cifs";
      options = [
        "rw,noauto,users,file_mode=0664,dir_mode=0775,noserverino,nohandlecache,noperm,uid=1000,credentials=/etc/win-credentials"
      ];
    };
    "/data/tools" = {
      device = "storage-nfs.prodrive.nl:/lnxtools";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "ro,nfsvers=3,proto=tcp,hard,intr,nolock,nosuid,nodev,noauto"
      ];
    };
    "/data/projects" = {
      device = "lnxdev02:/data/projects";
      fsType = "nfs";
      options = [
        "x-systemd.automount"
        "nfsvers=3,proto=tcp,hard,intr,nolock,nosuid,nodev,noauto"
      ];
    };
  };
}
