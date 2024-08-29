{
  plugins.lsp-lines.enable = true;
  diagnostics.virtual_lines.only_current_line = true;

  plugins = {
    lsp = {
      enable = true;

      servers = {
        bashls.enable = true;
        lua-ls.enable = true;
        clangd.enable = true;
        ruff-lsp.enable = true;

        pyright = {
          enable = true;

          settings = {
            pyright.disableOrganizeImports = true;
            python.analysis.ignore = [ "*" ];
          };
        };

        nixd = {
          enable = true;
          settings = {
            diagnostic = {
              suppress = [ "sema-escaping-width" "var-bind-to-this" ];
            };
          };
        };

        gopls.enable = true;
        tsserver.enable = true;
        ast-grep.enable = true;
        dockerls.enable = true;
        docker-compose-language-service.enable = true;
        jsonnet-ls.enable = true;
        marksman.enable = true;
     };
    };
    lsp-format = {
      enable = true;
      setup = {
        go = {
          exclude = [
            "gopls"
          ];
          force = true;
          sync = true;
        };
      };
    };
    lspsaga.enable = true;
  };
}
