{ config, pkgs, ... }: {
  # Needed for firefox and thunderbird
  home.packages = [ pkgs.libnotify ];

  services.mako = {
    enable = true;
    settings = {
      font = "TeX Gyre Adventor 10";
      iconPath = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark";
      padding = "10,20";
      anchor = "top-right";
      width = 400;
      height = 150;
      borderSize = 0;
      backgroundColor = "#1e1e2e";
      textColor = "#cdd6f4";
      borderColor = "#89b4fa";
      progressColor = "over #313244";

      defaultTimeout = 12000;
      layer = "overlay";
    };
    extraConfig = ''
      on-notify=exec ${pkgs.libcanberra-gtk3}/bin/canberra-gtk-play -i window-attention
      [app-name="prospect-mail"]
      invisible=1
      on-notify=exec :
      [app-name="Prospect Mail"]
      invisible=1
      on-notify=exec :
      [app-name="Spotify"]
      on-notify=exec :
    '';
  };
}
