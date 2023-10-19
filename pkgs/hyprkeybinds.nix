{ stdenv, pkgs, ... }:
let
  gnused = "${pkgs.gnused}/bin/sed";
  keybindScript = pkgs.writeShellScriptBin "hyprkeybinds" ''
    config_file=~/.config/hypr/hyprland.conf
    keybinds=$(${pkgs.gnugrep}/bin/grep -P '(?<=bind).*=.*' $config_file)
    keybinds=$(${pkgs.busybox}/bin/echo "$keybinds" | ${gnused} 's/bind.*=//g' | ${gnused} 's/,\([^,]\)/ = \1/2' | ${gnused} 's/exec,//g' | ${gnused} 's/^,//g' | ${gnused} 's/$,//g')
    ${pkgs.rofi}/bin/rofi -dmenu -p "Keybinds" -theme custom <<< "$keybinds"
  '';
in
stdenv.mkDerivation rec {
  name = "hyprkeybinds";
  src = keybindScript;
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/hyprkeybinds $out/bin/hyprkeybinds
  '';
}

