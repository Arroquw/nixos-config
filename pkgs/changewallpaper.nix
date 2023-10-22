{ stdenv, pkgs, ... }:
let
  wallpaperScript = pkgs.writeShellScriptBin "changewallpaper" ''
    DIR=$HOME/Desktop/wallpapers
    PICS=($(find -L ''${DIR} -maxdepth 1 -type f -exec basename {} \;))

    RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}

    if [[ $(pidof swaybg) ]]; then
      ${pkgs.procps}/bin/pkill swaybg
    fi

    ${pkgs.libnotify}/bin/notify-send -i ''${DIR}/''${RANDOMPICS} "Wallpaper Changed" ''${RANDOMPICS}
    ${pkgs.swaybg}/bin/swaybg -m fill -i ''${DIR}/''${RANDOMPICS}
    ${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play -i window-attention
  '';
in stdenv.mkDerivation rec {
  name = "changewallpaper";
  src = wallpaperScript;
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/changewallpaper $out/bin/changewallpaper
  '';
}

