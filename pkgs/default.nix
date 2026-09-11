{ pkgs }:
with pkgs;
{
  hyprkeybinds = callPackage ./hyprkeybinds.nix { };
  hyprpicker-script = callPackage ./hyprpicker-script.nix { };
  hyprshot = callPackage ./hyprshot.nix { };
  changewallpaper = callPackage ./changewallpaper.nix { };
  dcpl2530dwlpr = callPackage ./printer.nix { };
  dcpl2530dwlpr-scan = callPackage ./printer-scan.nix { };
  sf100linux = callPackage ./sf100linux.nix { };
  em100 = callPackage ./em100.nix { };
  sway-audio-idle-inhibit = callPackage ./idleinhibit.nix { };
  wayland-push-to-talk = callPackage ./wayland-push-to-talk.nix { };
  easyeda-pro = callPackage ./easyeda-pro.nix { };
  hypr-resolution = callPackage ./resolution.nix { };
}
