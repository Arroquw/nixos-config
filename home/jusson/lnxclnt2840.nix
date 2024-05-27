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
      workspace = [ "1" ];
    }
    {
      name = null;
      #name = "DP-4";
      desc = "Lenovo Group Limited LEN T27q-20 VNA77HCM";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 2560;
      workspace = [ "2" ];
      primary = true;
    }
    {
      name = null;
      #name = "DP-5";
      desc = "Lenovo Group Limited LEN T27q-20 VNA77HC8";
      width = 2560;
      height = 1440;
      refreshRate = 60;
      x = 0;
      workspace = [ "3" ];
    }
  ];
}
