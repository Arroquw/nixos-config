{ pkgs, ... }: {
  imports = [ ../../home ];

  programs = {
    git = {
      userName = "arroquw";
      userEmail = "justinvanson@outlook.com";
    };
  };

  arroquw = {
    hyprland = {
      enable = true;
      nvidiaPatches = true;
      mouseEnablesDpms = false;
      extraConfig = ''
        env=WLR_NO_HARDWARE_CURSORS,1
      '';
    };
  };

  services.swayidle = {
    timeouts = [{
      timeout = 5;
      command =
        "if ${pkgs.procps}/bin/pgrep -x swaylock && [ ! -f /tmp/swaylock.lock ]; then ${pkgs.hyprland}/bin/hyprctl dispatch dpms off; ${pkgs.busybox}/bin/touch /tmp/swaylock.lock; fi";
      resumeCommand = "${pkgs.busybox}/bin/rm -rf /tmp/swaylock.lock";
    }];
  };

  home = {
    sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:01:00.0-card";
    };
  };
  #  -----    ------
  # | DP-1| | DP-2 |
  #  -----    ------
  monitors = [
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      x = 0;
      workspace = "1";
      enabled = true;
    }
    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      x = 2560;
      workspace = "1";
      primary = true;
    }
  ];

}
