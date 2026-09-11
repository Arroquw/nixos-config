# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  self,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../common/global
    ../common/users
    ../common/optional/hyprland.nix
    ../common/optional/pipewire.nix
  ];

  security.sudo.extraRules =
    let
      systemctl = "/run/current-system/sw/bin/systemctl";
      units = [
        "/mnt/pd-common/copydrive"
        "/mnt/pd-user/projects"
        "data-projects.automount"
        "data-tools.automount"
      ];
    in
    [
      {
        groups = [ "wheel" ];
        commands =
          lib.concatMap
            (
              verb:
              map (unit: {
                command = "${systemctl} ${verb} ${unit}";
                options = [ "NOPASSWD" ];
              }) units
            )
            [
              "start"
              "restart"
            ];
      }
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
    libinput = {
      enable = true;
      touchpad.tapping = true; # tap
    };

    udev.packages = with self.packages.${pkgs.stdenv.hostPlatform.system}; [
      sf100linux
      em100
    ];
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    keyutils
    minicom
    curl
    libusb1
  ];

  environment.etc."request-key.conf" = {
    source = lib.mkForce (
      pkgs.writeText "request-key.conf" ''
        create id_resolver * * ${lib.getExe' pkgs.nfs-utils "nfsidmap"} -t 600 %k %d
        create dns_resolver * * /run/current-system/sw/bin/key.dns_resolver %k
      ''
    );
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
  users.extraGroups.vboxusers.members = [ "jusson" ];
}
