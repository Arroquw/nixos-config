_: {
  programs.nixvim = {
    plugins.comment-nvim = {
      enable = true;
      mappings = {
        basic = false;
        extra = false;
      };
    };
    keymaps = [
      {
        key = "<leader>/";
        action = ''
          function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end'';
        lua = true;
        options = {
          silent = true;
          desc = "Comment line";
        };
      }
      {
        mode = "v";
        key = "<leader>/";
        action =
          "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>";
        options = {
          silent = true;
          desc = "Comment line";
        };
      }
    ];
  };
}
