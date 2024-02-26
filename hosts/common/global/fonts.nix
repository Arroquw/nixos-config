{ pkgs, ... }: {

  fonts = {
    packages = with pkgs; [
      font-awesome
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka" ]; })
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = true;
        style = "full";
      };
      subpixel.lcdfilter = "default";
    };
  };
}
