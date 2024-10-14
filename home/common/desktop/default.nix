{ pkgs, ... }: {
  imports = [
    ./hypr
    ./rofi
    ./waybar
    ./ags
    ./gtk.nix
    ./mako.nix
    #./swayidle.nix
    #./swaylock.nix
  ];

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = "16";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };
}
