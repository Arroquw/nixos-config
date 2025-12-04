{ stdenv, ... }:

stdenv.mkDerivation {
  name = "hypr-resolution";

  src = ../scripts/resolution.sh;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/hypr-resolution
  '';
}

