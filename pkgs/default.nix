{ pkgs }:
with pkgs; {
  xwaylandvideobridge =
    pkgs.libsForQt5.callPackage ./xwaylandvideobridge.nix { };
  hyprkeybinds = callPackage ./hyprkeybinds.nix { };
  hyprpicker-script = callPackage ./hyprpicker-script.nix { };
  hyprshot = callPackage ./hyprshot.nix { };
  changewallpaper = callPackage ./changewallpaper.nix { };
  rofi-network-manager = callPackage ./rofi-network-manager.nix { };
  rofi-power-menu = callPackage ./rofi-power-menu.nix { };
  waybar-weather = callPackage ./weather.nix { };
  krisp-patch = callPackage ./krisp-patch.nix { };
}
