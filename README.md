# NixOS-Flake
My NixOS Flake + dotfiles

NixOS with personal packages running on HyprlandWM + Waybar

for wallpapers to work place all wallpapers in ./wallpapers/

SUPER + F1 for all keybinds!<br>

Credits go out to:
- nomadics9 (https://github.com/nomadics9/NixOS-Flake)
- misterio (https://github.com/Misterio77/nix-config) for home manager/flake layouts
- dacioromero (https://github.com/dacioromero/nix-config) for xwaylandvideobridge package
- jakehamilton (https://github.com/jakehamilton/config.git) for (inspiration for) appimage wrapper implementation

## To fix links not being clickable:

nix-shell -p desktop-file-utils --run "update-desktop-database ~/.local/share/applications"

mkdir ~/.config/xdg-desktop-portal/
cat > ~/.config/xdg-desktop-portal/portals.conf <<EOF
[preferred]
# use xdg-desktop-portal-gtk for every portal interface
default=gtk
# except for the xdg-desktop-portal-wlr supplied interfaces
org.freedesktop.impl.portal.Screencast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
EOF

systemctl --user restart xdg-desktop-portal.service
