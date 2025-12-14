{ stdenv, pkgs, lib, ... }:
let
  gnused = "${lib.getExe' pkgs.gnused "sed"}";
  keybindScript = pkgs.writeShellScriptBin "hyprkeybinds" ''
    config_file=~/.config/hypr/hyprland.conf
    keybinds=$(${
      lib.getExe' pkgs.gnugrep "grep"
    } -P '(?<=bind).*=.*' $config_file)
    keybinds=$(${
      lib.getExe' pkgs.busybox "echo"
    } "$keybinds" | ${gnused} 's/bind.*=//g' | ${gnused} 's/,\([^,]\)/ = \1/2' | ${gnused} 's/exec,//g' | ${gnused} 's/^,//g' | ${gnused} 's/$,//g')
    ${
      lib.getExe' pkgs.rofi "rofi"
    } -dmenu -p "Keybinds" -theme custom <<< "$keybinds"
  '';
in stdenv.mkDerivation {
  name = "hyprkeybinds";
  src = keybindScript;
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    install -Dm 744 $src/bin/hyprkeybinds $out/bin/hyprkeybinds
  '';
}

