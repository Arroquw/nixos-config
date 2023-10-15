{ pkgs }:
with pkgs; {
  xwaylandvideobridge = callPackage ./xwaylandvideobridge.nix { };
  hyprkeybinds = callPackage ./hyprkeybinds.nix { };
  hyprpicker-script = callPackage ./hyprpicker-script.nix { };
  hyprshot = callPackage ./hyprshot.nix { };
}
