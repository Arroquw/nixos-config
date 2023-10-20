{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "waybar-weather";

  src = ../scripts/waybar/weather.py;
  nativeBuildInputs = [
    (pkgs.python310.withPackages
      (pythonPackages: with pythonPackages; [ datetime requests ]))
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/waybar-weather
  '';
}

