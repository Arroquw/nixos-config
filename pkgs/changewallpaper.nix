{ stdenv, pkgs, coreutils, procps, busybox, sysvinit, findutils, bash, ... }:
let
  wallpaperScript = pkgs.writeShellScriptBin "changewallpaper" ''
    #!${pkgs.bash}/bin/bash
    DIR=$HOME/Desktop/wallpapers
    CURRENT=$(${pkgs.procps}/bin/pgrep -a swaybg | ${pkgs.gnused}/bin/sed -r 's/.*\-i\ (.*)/\1/g' | ${pkgs.findutils}/bin/xargs ${pkgs.coreutils}/bin/basename 2>/dev/null)
    PICS=($(${pkgs.findutils}/bin/find -L "''${DIR}" -maxdepth 1 ! -name "''${CURRENT}" -type f -exec ${pkgs.coreutils}/bin/basename {} \;))

    RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}

    if [[ $(${pkgs.sysvinit}/bin/pidof swaybg) ]]; then
      ${pkgs.procps}/bin/pkill swaybg
    fi

    ${pkgs.libnotify}/bin/notify-send -i ''${DIR}/''${RANDOMPICS} "Wallpaper Changed" ''${RANDOMPICS}
    ${pkgs.swaybg}/bin/swaybg -m fill -i ''${DIR}/''${RANDOMPICS}
    ${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play -i window-attention
  '';
in stdenv.mkDerivation {
  name = "changewallpaper";
  src = wallpaperScript;
  phases = "installPhase";

  buildInputs = with pkgs; [
    coreutils
    procps
    busybox
    gnused
    findutils
    sysvinit
    bash
  ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/changewallpaper $out/bin/changewallpaper
  '';
}

