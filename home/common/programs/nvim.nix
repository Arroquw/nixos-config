{ pkgs, config, lib, ... }:
with lib; {
  config = {
    home.file."./.config/nvim" = {
      source = "${pkgs.vimPlugins.nvchad}";
      recursive = true;
      executable = true;
    };

    programs.nixvim = { enable = true; };
  };
}
