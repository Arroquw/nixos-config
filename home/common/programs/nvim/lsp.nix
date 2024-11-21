{
  plugins.lsp-lines.enable = true;
  diagnostics.virtual_lines.only_current_line = true;

  plugins = {
    lsp = {
      enable = true;

      servers = {
        bashls.enable = true;
        lua_ls.enable = true;
        clangd.enable = true;
        ruff_lsp.enable = true;

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
        ts_ls.enable = true;
        ast_grep.enable = true;
        dockerls.enable = true;
        docker_compose_language_service.enable = true;
        jsonnet_ls.enable = true;
        marksman.enable = true;
      };
    };
    lsp-format = {
      enable = true;
      settings = {
        go = {
          exclude = [ "gopls" ];
          force = true;
          sync = true;
        };
      };
    };
    lspsaga = {
      enable = true;
      lightbulb.sign = false;
    };
  };
}
