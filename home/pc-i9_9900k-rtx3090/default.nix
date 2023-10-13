{ ... }: {
  imports = [ ../default.nix ];

  programs = {
    git = {
      userName = "arroquw";
      userEmail = "justinvanson@outlook.com";
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
