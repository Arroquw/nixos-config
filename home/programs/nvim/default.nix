{ pkgs, lib, ... }:
with lib; {
  imports = [ ./autocmd.nix ./comment.nix ];

  config = {
    home.file."./.config/nvim" = {
      source = "${pkgs.vimPlugins.nvchad}";
      recursive = true;
      executable = true;
    };

    programs.nixvim = { enable = true; };
  };
}
