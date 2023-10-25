{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/vm.nix
    ../../modules/shell.nix
    ../../modules/common.nix
    ./users.nix
  ];

  boot = {
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

  # Define your hostname
  networking = {
    hostName = "lnxclnt2840";
    # Enable networking
    networkmanager.enable = true;
    wireless.userControlled.enable = true;
    #Firewall
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    #For Chromecast from chrome
    #networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];
    # Or disable the firewall altogether.
    firewall.enable = false;
  };
  # Bluethooth
  hardware = {
    bluetooth.enable = true;
    pulseaudio.enable = false;
  };

  services = {
    xserver.libinput.enable = true;
    xserver.libinput.touchpad.tapping = true; # tap
    logind = {
      lidSwitchExternalPower = "ignore";
      lidSwitch = "hibernate";
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    keyutils
    minicom
    curl
    libusb1
  ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
