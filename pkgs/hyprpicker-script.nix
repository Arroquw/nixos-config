{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "hyprpicker-script";

  src = ../scripts/hyprland/hyprPicker.sh;
  dontUnpack = true;
  buildInputs = with pkgs; [ dunst imagemagick hyprpicker ];

  buildPhase = ''
    patchShebangs $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/hyprpicker-script
  '';
}

