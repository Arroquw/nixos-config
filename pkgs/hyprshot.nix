{ stdenv, pkgs, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "hyprshot";

  src = fetchFromGitHub {
    owner = "Gustash";
    repo = "Hyprshot";
    rev = "382bf0b042cbb1d878bf4a788400ebcb862ffad1";
    hash = "sha256-+LCQDilin6yKzfXjUV4MIhNHA/VXhuoh81rq0f0Wkso=";
  };

  buildInputs = with pkgs; [ slurp grim jq ];

  buildPhase = ''
    ls -alh
    patchShebangs hyprshot
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 hyprshot $out/bin/hyprshot
  '';
}

