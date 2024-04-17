# NixOS-Flake
My NixOS Flake + dotfiles

NixOS with personal packages running on HyprlandWM + Waybar

for wallpapers to work place all wallpapers in ./wallpapers/

SUPER + F1 for all keybinds!<br>

Credits go out to:
- nomadics9 (https://github.com/nomadics9/NixOS-Flake) For an easy to use starter config
- misterio (https://github.com/Misterio77/nix-config) for home manager/flake layouts
- jakehamilton (https://github.com/jakehamilton/config.git) for appimage wrapper implementation

## To fix links not being clickable:

First run:
```
nix-shell -p desktop-file-utils --run "update-desktop-database ~/.local/share/applications"
```
Then, create portals.conf:
```
mkdir ~/.config/xdg-desktop-portal/
cat > ~/.config/xdg-desktop-portal/portals.conf <<EOF
```
Add this content after the previous `cat` command:
```
[preferred]
# use xdg-desktop-portal-gtk for every portal interface
default=gtk
# except for the xdg-desktop-portal-wlr supplied interfaces
org.freedesktop.impl.portal.Screencast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
EOF
```
Then run:
```
systemd --user import-environment $PATH
systemctl --user restart xdg-desktop-portal.service
```
