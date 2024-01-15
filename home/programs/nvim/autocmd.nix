{
  programs.nixvim = {
    autoCmd = [
      {
        event = "TextYankPost";
        command =
          ''lua vim.highlight.on_yank { higroup = "Visual", timeout = 200 }'';
      }
      {
        event = "VimResized";
        command = ''lua vim.cmd "tabdo wincmd ="'';
      }
      {
        event = "BufWritePre";
        command = "%s/\\s\\+$//e"; # remove trailing whitespace
      }

      {
        event = "FileType";
        pattern = "julia";
        command =
          "setlocal textwidth=92 colorcolumn=+1 shiftwidth=4 tabstop=4 softtabstop=4";
      }
      {
        event = "FileType";
        pattern = "python";
        command = "setlocal tabstop=8 expandtab shiftwidth=4 softtabstop=4";
      }
      {
        event = "FileType";
        pattern = "markdown";
        command = "setlocal wrap";
      }
    ];
  };
}
