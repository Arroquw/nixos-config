# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }: {
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };
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
      options = [ "rw" "uid=1000" "nofail" "x-systemd.device-timeout=5s" ];
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-path/pci-0000:00:17.0-ata-6-part1";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" ];
    };

    "/mnt/intel-nvme" = {
      device = "/dev/disk/by-label/NVME_1TB";
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

  environment.etc."libvirt/qemu/networks/default.xml".text = ''
    <network>
      <name>default</name>
      <uuid>9a05da11-e96b-47f3-8253-a3a482e445f5</uuid>
      <forward mode='nat'/>
      <bridge name='virbr0' stp='on' delay='0'/>
      <mac address='52:54:00:0a:cd:21'/>
      <ip address='192.168.122.1' netmask='255.255.255.0'>
        <dhcp>
          <range start='192.168.122.2' end='192.168.122.254'/>
        </dhcp>
      </ip>
    </network>
  '';

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_full;
        runAsRoot = true;
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd pkgs.OVMFFull ];
        };
        swtpm.enable = true;
        verbatimConfig = ''
          cgroup_device_acl = [
              "/dev/null", "/dev/full", "/dev/zero",
              "/dev/random", "/dev/urandom",
              "/dev/ptmx", "/dev/kvm",
              "/dev/userfaultfd", "/dev/kvmfr0"
          ]
        '';
        vhostUserPackages = [ pkgs.virtiofsd ];
      };
      extraConfig = ''
        unix_sock_group = "libvirtd"
        unix_sock_rw_perms = "0770"
        log_filters="3:qemu 1:libvirt"
        log_outputs="2:file:/var/log/libvirt/libvirtd.log"
      '';
    };
    spiceUSBRedirection.enable = true;
  };
  users.extraGroups.vboxusers.members = [ "justin" ];

  systemd = {
    tmpfiles.rules = [
      "f /dev/shm/scream 0660 justin qemu-libvirtd -"
      "f /dev/shm/looking-glass 0660 justin qemu-libvirtd -"
      "f /dev/kvmfr0 0660 justin qemu-libvirtd -"
    ];
    user.services."amixer-mute-mic" = {
      description = "Mute listen back of Samson GOMIC";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = pkgs.writeShellScript "mute_mic_playback.sh" ''
          #!/usr/bin/env bash
          set -euo pipefail
          card=$(readlink /proc/asound/GoMic | grep -o '[0-9]' ||:)
          numid=$(${pkgs.alsa-utils}/bin/amixer -c "''${card}" controls | grep "'Mic Playback Switch'" | cut -d, -f1 | grep -o '[0-9]' ||:)
          ${pkgs.alsa-utils}/bin/amixer -c "''${card}" cset numid="''${numid}" mute
        '';
      };
    };
  };

  services.udev.extraRules = ''
    ATTRS{idProduct}=="beba", ATTRS{idVendor}=="1209", MODE:="666"
    ATTRS{idProduct}=="3752", ATTRS{idVendor}=="0483", MODE:="666"
  '';
}
