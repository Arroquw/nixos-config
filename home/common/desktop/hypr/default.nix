{ lib, self, config, pkgs, ... }: {

  home.packages = with pkgs; [ swww ];

  wayland.windowManager.hyprland = let
    modifiers = if config.home.username == "jusson" then
      "env = WLR_DRM_NO_MODIFIERS,1"
    else
      "";
  in {
    enable = true;
    xwayland.enable = true;
    settings = import ./config.nix { inherit config self pkgs lib; };
    extraConfig = ''
      env = WLR_DRM_NO_ATOMIC,1
    '' + modifiers;
  };
}
