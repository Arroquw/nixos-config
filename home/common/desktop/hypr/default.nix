{
  lib,
  self,
  config,
  pkgs,
  inputs,
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
    plugins = [
      inputs.hyprwm-contrib.packages.${pkgs.stdenv.hostPlatform.system}.hyprprop
    ];
  };

  home.packages = with pkgs; [
    grim
    hyprprop
    hyprsysteminfo
    slurp
  ];

  services.hyprpolkitagent.enable = true;
  programs.hyprshot.enable = true;

  systemd.user.services.hyprpolkitagent.Unit = {
    After = lib.mkAfter [ "xdg-desktop-portal.service" ];
    Wants = [ "xdg-desktop-portal.service" ];
  };

}
