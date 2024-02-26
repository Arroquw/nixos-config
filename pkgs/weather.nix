{ stdenv, pkgs, nix, ... }:

stdenv.mkDerivation {
  name = "waybar-weather";

  src = ../scripts/waybar/weather.py;
  buildInputs = [
    nix
    (pkgs.python310.withPackages
      (pythonPackages: with pythonPackages; [ hjson requests ]))
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/waybar-weather
  '';
}

