{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "changewallpaper";

  src = ../scripts/waybar/changewallpaper.sh;
  dontUnpack = true;

  buildPhase = ''
    patchShebangs $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/changewallpaper
  '';
}

