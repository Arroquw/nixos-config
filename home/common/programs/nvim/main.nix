_: {
  viAlias = true;
  vimAlias = false;

  luaLoader.enable = true;
  editorconfig.enable = true;

  plugins = {
    lualine.enable = true;
    comment.enable = true;
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
      modules = {
        surround = { };
        trailspace = { };
      };
    };

    nvim-tree = {
      enable = true;
      git.enable = true;
      renderer = {
        highlightGit = true;
        highlightModified = "icon";
      };
      diagnostics.enable = true;
    };

    nvim-autopairs.enable = true;
    luasnip.enable = true;

    tmux-navigator.enable = true;

    lint.enable = true;
    guess-indent.enable = true;
    gitignore.enable = true;
    git-conflict.enable = true;
    nix.enable = true;
  };
}
