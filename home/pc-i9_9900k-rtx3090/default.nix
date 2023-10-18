{ ... }: {
  imports = [ ../default.nix ];

  programs = {
    git = {
      userName = "arroquw";
      userEmail = "justinvanson@outlook.com";
    };
  };

  wayland.windowManager.hyprland = {
    enableNvidiaPatches = true;
    extraConfig = ''
      env=WLR_NO_HARDWARE_CURSORS,1
    '';
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
