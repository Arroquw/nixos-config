{ pkgs, lib, config, ... }:
with lib;
let cfg = config.arroquw.games;
in {
  options.arroquw.games = {
    enable = mkEnableOption "Whether to include games or not";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;

    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
            gamescope
            mangohud
            busybox
            openssl
            libxcrypt
          ];
        extraEnv = {
          MANGOHUD = true;
          RADV_TEX_ANISO = 16;
        };
      };
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      remotePlay.openFirewall = true;
    };
    environment.systemPackages = with pkgs; [ protontricks ];
  };
}
