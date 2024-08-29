{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      ((discord.override {
        withOpenASAR = true;
        nss = pkgs.nss_latest;
      }).overrideAttrs (old: {
        libPath = old.libPath + ":${pkgs.libglvnd}/lib";
        nativeBuildInputs = old.nativeBuildInputs ++ [ pkgs.makeWrapper ];

        postFixup = ''
          wrapProgram $out/opt/Discord/Discord --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform=wayland}} --use-gl=desktop"
        '';
      }))
    ];
}
