{ pkgs, ... }: {
  gtk = {
    enable = true;
    font.name = "TeX Gyre Adventor 10";
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = null;

    gtk3 = {
      theme = {
        name = "Juno";
        package = pkgs.juno-theme;
      };
      extraConfig = {
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-application-prefer-dark-theme = 1;
      };
    };

    gtk2 = {
      theme = {
        name = "Juno";
        package = pkgs.juno-theme;
      };
      extraConfig = ''
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
      '';
    };

    gtk4 = {
      theme = {
        name = "Adwaita-dark";
        package = pkgs.adwaita-qt;
      };
      extraConfig = { gtk-application-prefer-dark-theme = 1; };
    };
  };
}
