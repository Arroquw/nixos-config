{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "changewallpaper";

  src = ../scripts/waybar/changewallpaper.sh;
  dontUnpack = true;
  buildInputs = with pkgs; [
    dunst
    imagemagick
    hyprpicker
  ];

  buildPhase = ''
    patchShebangs $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/changewallpaper
  '';
}

