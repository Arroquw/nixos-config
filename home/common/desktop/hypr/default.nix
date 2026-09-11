{
  lib,
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "lua";
    settings = import ./hyprland.nix {
      inherit
        config
        self
        pkgs
        lib
        ;
    };
    package = null;
    portalPackage = null;
  };

  home.packages = with pkgs; [
    grim
    hyprprop
    hyprsysteminfo
    slurp
  ];

  services.blueman-applet.enable = true;

  services.hyprpolkitagent.enable = true;

  systemd.user.services.hyprpolkitagent.Unit = {
    After = lib.mkAfter [ "xdg-desktop-portal.service" ];
    Wants = [ "xdg-desktop-portal.service" ];
  };

}
