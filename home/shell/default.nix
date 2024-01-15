{ pkgs, ... }: {
  imports = [ ./bash.nix ./direnv.nix ./git.nix ./starship.nix ];

  home.packages = with pkgs; [
    ripgrep # Better grep
    btop
    bc # Calculator
    fd # Better find
    nil # Nix LSP
    nixfmt # Nix formatter
    deadnix
  ];
}
