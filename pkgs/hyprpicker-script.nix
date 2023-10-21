{ stdenv, pkgs, ... }:
let
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  hyprpicker = "${pkgs.hyprpicker}/bin/hyprpicker";
  hyprpickerScript = pkgs.writeShellScriptBin "hyprpicker-script" ''
    ${hyprpicker} --format hex | ${pkgs.busybox}/bin/head -c -1 | ${wl-copy}
    ${pkgs.imagemagick}/bin/convert -size 100x100 xc:$(${wl-paste}) /tmp/color.png
    ${pkgs.dunst}/bin/dunstify --icon=/tmp/color.png "$(${wl-paste})"  "Copied to your clipboard!"
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

