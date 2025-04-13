# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }: {
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
    games.enable = true;
  };

  time.hardwareClockInLocalTime = true;

  services = {
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire.wireplumber = {
      configPackages = [
        (pkgs.writeTextDir
          "share/wireplumber/wireplumber.conf.d/51-alsa-disable.conf" ''
            rule = {
                matches = {
                  {
                    { "device.name","equals","alsa_card.pci-0000_01_00.1" },
                  },
                },
                apply_properties = {
                  ["device.disabled"] = true,
                },
              }

              table.insert(alsa_monitor.rules,rules)
          '')
      ];
    };
  };

  fileSystems = {
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

  environment.etc."drirc" = {
    source = pkgs.writeText "drirc" ''
      <driconf>
      </driconf>
    '';
  };

  virtualisation = {
    virtualbox.host.enable = true;
    vmware.host.enable = true;
    virtualbox.host.enableExtensionPack = true;
  };
  users.extraGroups.vboxusers.members = [ "justin" ];

  systemd.user.services."amixer-mute-mic" = {
    description = "Mute listen back of Samson GOMIC";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = pkgs.writeShellScript "mute_mic_playback.sh" ''
        #!/usr/bin/env bash
        set -euo pipefail
        card=$(readlink /proc/asound/GoMic | grep -o '[0-9]' ||:)
        numid=$(amixer -c "''${card}" controls | grep "'Mic Playback Switch'" | cut -d, -f1 | grep -o '[0-9]' ||:)
        amixer -c "''${card}" cset numid="''${numid}" mute
      '';
    };
  };

  services.udev.extraRules = ''
    ATTRS{idProduct}=="beba", ATTRS{idVendor}=="1209", MODE:="666"
    ATTRS{idProduct}=="3752", ATTRS{idVendor}=="0483", MODE:="666"
  '';
}
