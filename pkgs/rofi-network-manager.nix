{ pkgs, stdenv, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "rofi-network-manager";

  src = fetchFromGitHub {
    owner = "P3rf";
    repo = "rofi-network-manager";
    rev = "19a3780fa3ed072482ac64a4e73167d94b70446b";
    hash = "sha256-sK4q+i6wfg9k/Zjszy4Jf0Yy7dwaDebTV39Fcd3/cQ0=";
  };

  buildPhase = ''
    ls -alh
    sed -ri 's@rofi -dmenu@${pkgs.rofi}/bin/rofi -dmenu@g' rofi-network-manager.sh
    patchShebangs rofi-network-manager.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 rofi-network-manager.sh $out/bin/rofi-network-manager
  '';
}

