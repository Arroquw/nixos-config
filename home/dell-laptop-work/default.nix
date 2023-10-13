_: {
  imports = [ ../default.nix ];

  programs = {
    git = {
      userName = "justinvson-pd";
      userEmail = "justin.van.son@prodrive-technologies.com";
    };
  };

  #  ------   -----   ------
  # |  DP-5  | |  DP-4  |
  #            |eDP-1|
  #  ------   -----   ------
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      x = 0;
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
  ];
}
