{ pkgs, ... }: {
  imports = [
    ../common/global.nix

    ../common/desktop
    ../common/programs

    #inputs.spicetify-nix.homeManagerModule
  ];

  home = {
    username = "justin";

    packages = with pkgs; [ gnome-calculator ];

    file = {
      ".config/citra-emu/sdl2-config.ini".source =
        ../../scripts/sdl2-config.ini;
    };
  };

  monitors = [
    {
      name = "DP-4";
      desc = "Dell Inc. DELL U2719D CK3WTS2";
      width = 2560;
      height = 1440;
      workspace = [ "2" "5" ];
    }
    {
      name = "DP-5";
      desc = "Microstep MAG274QRF-QD CA8A270B00307";
      width = 2560;
      height = 1440;
      refreshRate = 165;
      x = 2560;
      primary = true;
      vrr = 2;
    }
    {
      name = "Unknown-1";
      enabled = false;
    }
  ];
}
