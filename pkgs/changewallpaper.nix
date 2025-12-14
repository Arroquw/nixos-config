{ stdenv, pkgs, coreutils, procps, busybox, sysvinit, findutils, bash, lib, ...
}:
let
  wallpaperScript = pkgs.writeShellScriptBin "changewallpaper" ''
    #!${lib.getExe' pkgs.bash "bash"}
    DIR=$HOME/Desktop/wallpapers
    CURRENT=$(${lib.getExe' pkgs.procps "pgrep"} -a swaybg | ${
      lib.getExe' pkgs.gnused "sed"
    } -r 's/.*\-i\ (.*)/\1/g' | ${lib.getExe' pkgs.findutils "xargs"} ${
      lib.getExe' pkgs.coreutils "basename"
    } 2>/dev/null)
    PICS=($(${
      lib.getExe' pkgs.findutils "find"
    } -L "''${DIR}" -maxdepth 1 ! -name "''${CURRENT}" -type f -exec ${
      lib.getExe' pkgs.coreutils "basename"
    } {} \;))

    RANDOMPICS=''${PICS[ $RANDOM % ''${#PICS[@]} ]}

    if [[ $(${lib.getExe' pkgs.sysvinit "pidof"} swaybg) ]]; then
      ${lib.getExe' pkgs.procps "pkill"} swaybg
    fi

    ${
      lib.getExe' pkgs.libnotify "notify-send"
    } -i ''${DIR}/''${RANDOMPICS} "Wallpaper Changed" ''${RANDOMPICS}
    ${lib.getExe' pkgs.swaybg "swaybg"} -m fill -i ''${DIR}/''${RANDOMPICS}
    ${lib.getExe' pkgs.libcanberra-gtk3 "canberra-gtk-play"} -i window-attention
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

