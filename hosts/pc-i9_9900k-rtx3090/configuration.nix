{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/vm.nix
    ../../modules/shell.nix
    ../../modules/common.nix
    ./users.nix
    ../../modules/nvidia.nix
  ];

  nixpkgs.config.nvidia.acceptLicense = true;

  boot = {
    initrd = { kernelModules = [ "nvidia" ]; };
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
    supportedFilesystems = [ "ntfs" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
      };
    };
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

  # Define your hostname
  networking = {
    hostName = "NixOS-justin";
    # Enable networking
    networkmanager.enable = true;
    #Firewall
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    #For Chromecast from chrome
    #networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];
    # Or disable the firewall altogether.
    firewall.enable = false;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
  };

  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
    primus
    bumblebee
  ];

  services.logind.extraConfig = ''
    RuntimeDirectorySize=10G
  '';

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
