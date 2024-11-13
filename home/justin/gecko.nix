{ pkgs, ... }: {
  imports = [
    ../common/global.nix

    ../common/desktop
    ../common/programs

    #inputs.spicetify-nix.homeManagerModule
  ];

  home.username = "justin";

  home.packages = with pkgs; [ gnome-calculator ];

  home.file = {
    ".config/citra-emu/sdl2-config.ini".source = ../../scripts/sdl2-config.ini;
  };

  monitors = [
    {
      name = "DP-3";
      width = 2560;
      height = 1440;
      workspace = [ "2" "5" ];
    }
    {
      name = "DP-2";
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
