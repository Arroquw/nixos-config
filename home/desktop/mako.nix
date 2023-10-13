{ config, ... }:
let inherit (config.colorscheme) colors;
in {
  services.mako = {
    enable = true;
    font = "TeX Gyre Adventor 10";
    iconPath = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark";
    padding = "10,20";
    anchor = "top-center";
    width = 400;
    height = 150;
    borderSize = 0;
    defaultTimeout = 12000;
    backgroundColor = "#${colors.base00}dd";
    borderColor = "#${colors.base03}dd";
    textColor = "#${colors.base05}dd";
    layer = "overlay";
    extraConfig = ''
      on-notify="exec canberra-gtk-play -i window-attention";
      [app-name="prospect-mail"]
      invisible=1
      [app-name="Prospect Mail"]
      invisible=1
      [app-name="Spotify"]
      on-notify=exec ":"
    '';
  };
}

