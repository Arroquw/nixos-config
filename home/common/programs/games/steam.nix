{ pkgs, ... }:
let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [ gamescope mangohud ];
  };
  steam-session =
    pkgs.writeTextDir "share/wayland-sessions/steam-session.desktop" ''
      [Desktop Entry]
      Name=Steam Session
      Exec=${pkgs.gamescope}/bin/gamescope -W 3440 -H 1440 -O DP-1 -e -- steam
      Type=Application
    '';
in {
  home.packages = with pkgs; [
    steam-with-pkgs
    steam-session
    gamescope
    mangohud
  ];
}
