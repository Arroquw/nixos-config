{ pkgs, ... }: {

  fonts = {
    packages = with pkgs; [
      font-awesome
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
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
