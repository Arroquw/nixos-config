{ pkgs }:
with pkgs; {
  hyprkeybinds = callPackage ./hyprkeybinds.nix { };
  hyprpicker-script = callPackage ./hyprpicker-script.nix { };
  hyprshot = callPackage ./hyprshot.nix { };
  changewallpaper = callPackage ./changewallpaper.nix { };
  rofi-network-manager = callPackage ./rofi-network-manager.nix { };
  rofi-power-menu = callPackage ./rofi-power-menu.nix { };
  waybar-weather = callPackage ./weather.nix { };
  krisp-patch = callPackage ./krisp-patch.nix { };
  dcpl2530dwlpr = callPackage ./printer.nix { };
  dcpl2530dwlpr-scan = callPackage ./printer-scan.nix { };
  sf100linux = callPackage ./sf100linux.nix { };
  em100 = callPackage ./em100.nix { };
  sway-audio-idle-inhibit = callPackage ./idleinhibit.nix { };
  wayland-push-to-talk = callPackage ./wayland-push-to-talk.nix { };
  realvnc = callPackage ./realvnc.nix { };
  easyeda-pro = callPackage ./easyeda-pro.nix { };
}
