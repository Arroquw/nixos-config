{ config, pkgs, lib, inputs, modulesPath, ... }: {
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Include the results of the hardware scan.
  imports = [
    ./hardware-configuration.nix
    ../../modules/vm.nix
    ../../modules/shell.nix
    ./users.nix
  ];

  nixpkgs.config.allowUnfree = true;

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
  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
  ];
  #emojis
  #services.gollum.emoji = true;

  # Define your hostname
  networking.hostName = "lnxclnt2840";
  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.userControlled.enable = true;
  # Bluethooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    #isDefault
    #wireplumber.enable= true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  #Services
  services.xserver.enable = true;
  #  services.flatpak.enable = true;
  services.locate.enable = true;
  services.printing.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = true; # tap
  services.logind = {
    lidSwitchExternalPower = "ignore";
    #lidSwitchDock = "ignore";
    lidSwitch = "hibernate";
  };
  services.tlp.enable = true;
  services.upower.enable = true;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };

  #Display
  # Enable Gnome login
  services.xserver.displayManager = {
    gdm.enable = true;
    gdm.wayland = true;
  };
  #services.xserver.displayManager.gdm.settings = {};

  #xdg
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      #xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
    wlr.enable = true;
  };

  #SystemPackages
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim
    zig
    wget
    killall
    git
    neofetch
    gh
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    #xdg-desktop-portal-hyprland
    xwayland
    meson
    busybox
    konsole
    dolphin
    read-edid
    cloud-utils
    go
    nwg-look
    appimage-run
    mesa
    cifs-utils
    keyutils
    minicom
  ];

  #Firewall
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  #For Chromecast from chrome
  #networking.firewall.allowedUDPPortRanges = [ { from = 32768; to = 60999; } ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
