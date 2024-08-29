{ pkgs, nixvim, ... }: {
  imports = [
    ./firefox.nix
    ./kitty.nix
    ./games
    ./direnv.nix
    # ./xdg.nix
  ];

  home.packages = with pkgs; [
    gnumake
    neofetch
    catppuccin-cursors.mochaDark

    # Utils
    pamixer

    # Productivity
    obsidian

    # Screenshot
    grim
    slurp
    (nixvim.legacyPackages."${pkgs.stdenv.hostPlatform.system}".makeNixvimWithModule {
      inherit pkgs;
      module = import ./nvim;
    })
  ];
}
