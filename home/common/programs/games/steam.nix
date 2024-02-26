{ pkgs, lib, ... }:
let
  steam-with-pkgs = pkgs.steam.override {
    extraPkgs = pkgs:
      with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        gamescope
        mangohud
      ];
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
    protontricks
  ];
}
