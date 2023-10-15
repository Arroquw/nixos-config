{ stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  name = "hyprkeybinds";

  src = ../scripts/hyprland/keybind;
  dontUnpack = true;
  buildInputs = with pkgs; [ gnused ];

  buildPhase = ''
    patchShebangs $src
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src $out/bin/hyprkeybinds
  '';
}

