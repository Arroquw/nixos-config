# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
_: {
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users/justin
    ../common/optional/hyprland.nix
    ../common/optional/pipewire.nix
  ];

  arroquw = {
    desktop = {
      enable = true;
      hostname = "gecko";
      gfxmodeEfi = "2560x1440";
    };
    nvidia.enable = true;
  };

  fileSystems = {
    "/mnt/newvolume" = {
      device = "/dev/disk/by-path/pci-0000:00:17.0-ata-2-part2";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/mnt/brokenconn" = {
      device = "/dev/disk/by-path/pci-0000:00:17.0-ata-4-part2";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-path/pci-0000:00:17.0-ata-6-part1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/mnt/intel-nvme" = {
      device = "/dev/disk/by-path/pci-0000:03:00.0-nvme-1-part2";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/mnt/windows" = {
      device = "/dev/disk/by-path/pci-0000:02:00.0-nvme-1-part2";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };
  };
}