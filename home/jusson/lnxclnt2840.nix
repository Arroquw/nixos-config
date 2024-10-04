{ pkgs, ... }: {
  imports = [
    ../common/global.nix
    ../common/desktop
    ../common/programs
    #inputs.spicetify-nix.homeManagerModule
  ];

  home.username = "jusson";

  home.packages = with pkgs; [ thunderbird gnome.gnome-calculator ];
  #  ------   -----   ------
  # | DP-5/7 | | DP-4/6 |
  #              |eDP-1|
  #  ------   -----   ------
  monitors = [
    {
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1920;
      y = 1440;
      workspace = [ "1" "4" ];
    }
    {
      name = "DP-4";
      desc = "Dell Inc. DELL U2719D DVQ1SS2";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 2560;
      workspace = [ "2" "5" ];
      primary = true;
    }
    {
      name = "DP-5";
      desc = "Dell Inc. DELL U2719D 3VQ1SS2";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 0;
      workspace = [ "3" "6" ];
    }
  ];
}
