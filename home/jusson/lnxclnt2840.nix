{ pkgs, ... }: {
  imports = [
    ../common/global.nix
    ../common/desktop
    ../common/programs
    #inputs.spicetify-nix.homeManagerModule
  ];

  home.username = "jusson";

  home.packages = with pkgs; [ thunderbird gnome-calculator ];
  #  ------   -----   ------
  # | DP-4/6 | | DP-5/7 |
  #              |eDP-1|
  #  ------   -----   ------
  monitors = let
    left = "Dell Inc. DELL U2722D 2H9TQ83";
    right = "Dell Inc. DELL U2722D CC9TQ83";
  in [
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
      name = "DP-5";
      desc = right;
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 2560;
      workspace = [ "2" "5" ];
      primary = true;
    }
    {
      name = "DP-4";
      desc = left;
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 0;
      workspace = [ "3" "6" ];
    }
  ];
}
