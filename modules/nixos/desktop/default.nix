{ lib, pkgs, config, inputs, ... }:
with lib;
let cfg = config.arroquw.desktop;
in {
  options.arroquw.desktop = {
    enable = mkEnableOption "the default desktop configuration";

    hostname = mkOption {
      type = types.str;
      default = null;
      example = "deepblue";
      description = "hostname to identify the instance";
    };

    gfxmodeEfi = mkOption {
      type = types.str;
      default = "auto";
      example = "1024x768";
      description =
        "The gfxmode to pass to GRUB when loading a graphical boot interface under EFI.";
    };
  };

  config = mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    boot.loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 5;
        inherit (cfg) gfxmodeEfi;
        theme = pkgs.fetchzip {
          # https://github.com/AdisonCavani/distro-grub-themes
          url =
            "https://github.com/AdisonCavani/distro-grub-themes/raw/master/themes/nixos.tar";
          hash = "sha256-ivi68lkV2mypf99BOEnRiTpc4bqupfGJR7Q0Fm898kM=";
          stripRoot = false;
        };
      };
    };

    # Enable networkmanager
    networking = {
      networkmanager.enable = true;

      extraHosts = ''
        192.168.178.61  gecko
        192.168.178.23 thomeserver
        192.168.178.217 lnxclnt2840
      '';
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 21 22 25 53 110 143 445 3389 5900 ];
        extraCommands = ''
          iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
          iptables -I OUTPUT 1 -m owner --gid-owner no-internet -j DROP
        '';
      };
      # Define the hostname
      hostName = cfg.hostname;
    };
    services = {
      xserver = {
        # Enable the X11 windowing system.
        enable = true;

        # Configure keymap in X11
        xkb = {
          layout = "us";
          variant = "";
        };
      };

      # Enable CUPS to print documents.
      printing.enable = true;

      gnome.gnome-keyring.enable = true;

      gvfs.enable = true; # Thunar mount, trash, and other functionalities
      tumbler.enable = true; # Thunar thumbnail support for images
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      ];
      #wlr.enable = true;
      config.common.default = [ "*" ];
    };

    # TODO: decide what to do with this
    environment.variables = let
      modifiers = lib.optionalAttrs (cfg.hostname == "lnxclnt2840") {
        WLR_DRM_NO_MODIFIERS = "1";
        AQ_NO_MODIFIERS = "1";
      };
    in {
      BROWSER = "firefox";
      NIXOS_OZONE_WL = "1";
      DIRENV_LOG_FORMAT = "";
      MOZ_ENABLE_WAYLAND = "1";
      CLUTTER_BACKEND = "wayland";
    } // modifiers;

    programs = {
      file-roller.enable = true;
      thunar = {
        enable = true;
        plugins = with pkgs.xfce; [
          thunar-archive-plugin
          thunar-volman
          thunar-media-tags-plugin
        ];
      };
      seahorse.enable = true;
    };

    hardware.graphics.enable = true;
  };
}
