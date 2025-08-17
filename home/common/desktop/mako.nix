{ config, pkgs, ... }: {
  # Needed for firefox and thunderbird
  home.packages = [ pkgs.libnotify ];

  services.mako = {
    enable = true;

    settings = {
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      progress-color = "over #313244";
      font = "TeX Gyre Adventor 10";
      icon-path = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark";
      padding = "10,20";
      anchor = "top-right";
      width = 400;
      height = 150;
      border-size = 0;
      default-timeout = 12000;
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
