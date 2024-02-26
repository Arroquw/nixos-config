{ pkgs, ... }: {
  imports = [ ./steam.nix ];

  home.packages = with pkgs; [ gamescope osu-lazer ];
}
