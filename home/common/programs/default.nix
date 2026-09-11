{ pkgs, nixvim, ... }:
{
  imports = [
    ./firefox.nix
    ./kitty.nix
  ];

  home.packages = with pkgs; [
    gnumake
    fastfetch
    catppuccin-cursors.mochaDark

    # Utils
    pamixer

    (nixvim.legacyPackages."${pkgs.stdenv.hostPlatform.system}".makeNixvimWithModule {
      inherit pkgs;
      module = import ./nvim;
    })
  ];
}
