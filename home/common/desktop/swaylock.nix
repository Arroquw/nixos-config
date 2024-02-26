{ pkgs, ... }: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      ignore-empty-password = true;
      font = "Liga SFMono Nerd Font";

      image =
        "~/Desktop/wallpapers/lockscreen/serey-morm-Z9G2Cm3n080-unsplash.jpg";

      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 10;
      indicator-caps-lock = true;

      clock = true;
      #        key-hl-color = "#8aadf4";
      key-hl-color = "#26942e";
      bs-hl-color = "#ed8796";
      caps-lock-key-hl-color = "#f5a97f";
      caps-lock-bs-hl-color = "#ed8796";

      separator-color = "#18261d";

      inside-color = "#243a27";
      inside-clear-color = "#227740";
      inside-caps-lock-color = "#243a27";
      inside-ver-color = "#243a27";
      inside-wrong-color = "#243a27";

      ring-color = "#1e3020";
      ring-clear-color = "#26942e";
      ring-caps-lock-color = "#231f20";
      ring-ver-color = "#1e2030";
      ring-wrong-color = "#ed8796";

      line-color = "#26942e";
      line-clear-color = "#26942e";
      line-caps-lock-color = "#f5a97f";
      line-ver-color = "#18261d";
      line-wrong-color = "#ed8796";

      text-color = "#26942e";
      text-clear-color = "#24273a";
      text-caps-lock-color = "#f5a97f";
      text-ver-color = "#24273a";
      text-wrong-color = "#24273a";

      debug = true;
    };
  };
}
