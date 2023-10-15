{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "waybar-weather";

  src = ../scripts/waybar/weather.py;
  propagatedBuildInputs = [
    (pkgs.python38.withPackages
      (pythonPackages: with pythonPackages; [ consul six ]))
  ];
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/waybar-weather
  '';
}

