{ stdenv, pkgs, lib, ... }:
let
  wl-paste = "${lib.getExe' pkgs.wl-clipboard "wl-paste"}";
  wl-copy = "${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
  hyprpicker = "${lib.getExe' pkgs.hyprpicker "hyprpicker"}";
  hyprpickerScript = pkgs.writeShellScriptBin "hyprpicker-script" ''
    ${hyprpicker} --format hex | ${
      lib.getExe' pkgs.busybox "head"
    } -c -1 | ${wl-copy}
    ${
      lib.getExe' pkgs.imagemagick "convert"
    } -size 100x100 xc:$(${wl-paste}) /tmp/color.png
    ${
      lib.getExe' pkgs.dunst "dunstify"
    } --icon=/tmp/color.png "$(${wl-paste})"  "Copied to your clipboard!"
  '';
in stdenv.mkDerivation {
  name = "hyprpicker-script";
  src = hyprpickerScript;
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/hyprpicker-script $out/bin/hyprpicker-script
  '';
}

