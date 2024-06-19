{ pkgs, ... }: {
  imports = [ ./runelite.nix ];

  home.packages = with pkgs; [ gamescope gamemode ];
}
