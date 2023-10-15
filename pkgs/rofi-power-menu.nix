{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "rofi-power-menu";
  
  src = ../scripts/rofi/bin/power-menu.sh;
  dontUnpack = true;
  buildPhase = ''
    ls -alh
    patchShebangs $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/rofi-power-menu
  '';
}

