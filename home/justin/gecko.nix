{ pkgs, ... }: {
  imports = [
    ../common/global.nix

    ../common/desktop
    ../common/programs

    #inputs.spicetify-nix.homeManagerModule
  ];

  home.username = "justin";

  home.packages = with pkgs; [ thunderbird gnome.gnome-calculator ];

  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
    }

    {
      name = "DP-2";
      width = 2560;
      height = 1440;
      x = 2560;
      primary = true;
    }
  ];
}
