_: {
  viAlias = true;
  vimAlias = false;

  luaLoader.enable = true;
  editorconfig.enable = true;

  plugins = {
    lualine.enable = true;
    comment = {
      enable = true;
      settings = {
        opleader = {
          block = "<leader>\\";
          line = "<leader>/";
        };
        toggler = {
          block = "<leader>\\";
          line = "<leader>/";
        };
      };
    };
    todo-comments.enable = true;

    refactoring = {
      enable = true;
      enableTelescope = true;
    };

    indent-blankline = {
      enable = true;
      settings.indent.char = "¦";
    };

    mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        surround = { };
        trailspace = { };
      };
    };

    nvim-tree = {
      enable = true;
      settings = {
        git.enable = true;
        renderer = {
          highlight_git = "all";
          highlight_modified = "icon";
          highlight_clipboard = "name";
        };
        diagnostics.enable = true;
      };
    };

    nvim-autopairs.enable = true;
    colorizer.enable = true;
    luasnip.enable = true;

    tmux-navigator.enable = true;

    lint.enable = true;
    guess-indent.enable = true;
    gitignore.enable = true;
    git-conflict.enable = true;
    nix.enable = true;
    rustaceanvim.enable = true;
    bufferline.enable = true;
  };
}
