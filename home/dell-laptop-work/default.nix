_: {
  imports = [ ../../home ];
  programs = {
    git = {
      userName = "justinvson-pd";
      userEmail = "justin.van.son@prodrive-technologies.com";
    };
  };

  home.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/by-path/pci-0000:00:02.0-card";
  };

  #  ------   -----   ------
  # | DP-5/7 | | DP-4/6 |
  #              |eDP-1|
  #  ------   -----   ------
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      x = 1920;
      y = 1440;
      workspace = "1";
    }
    {
      name = "DP-4";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 1920;
      workspace = "2";
      primary = true;
    }
    { # TODO: fix 1440p not working in docked mode
      name = "DP-5";
      width = 1920;
      height = 1200;
      x = 0;
      workspace = "3";
    }
    {
      name = "DP-6";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 1920;
      workspace = "2";
    }
    { # TODO: fix 1440p not working in docked mode
      name = "DP-7";
      width = 1920;
      height = 1200;
      x = 0;
      workspace = "3";
    }
  ];
}
