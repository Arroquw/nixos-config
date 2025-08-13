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
            gamescope-wsi
            gamescope
            gamemode
            mangohud
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
