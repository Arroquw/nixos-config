{ lib, self, config, pkgs, ... }: {

  home.packages = with pkgs; [ swww ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = import ./config.nix { inherit config self pkgs lib; };
  };
}
