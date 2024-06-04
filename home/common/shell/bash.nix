{ pkgs, ... }: {
  home.packages = with pkgs; [ zsh-fzf-history-search fzf-zsh fzf ];
  programs = {
    bash = {
      enable = true;
      bashrcExtra = ''
        function fuck () {
          TF_PYTHONIOENCODING=$PYTHONIOENCODING;
          export TF_SHELL=bash;
          export TF_ALIAS=fuck;
          export TF_SHELL_ALIASES=$(alias);
          export TF_HISTORY=$(fc -ln -10);
          export PYTHONIOENCODING=utf-8;
          TF_CMD=$(
            thefuck THEFUCK_ARGUMENT_PLACEHOLDER "$@"
          ) && eval "$TF_CMD";
          unset TF_HISTORY;
          export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
          history -s $TF_CMD;
        }
      '';
    };
    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "fzf" "git" "thefuck" ];
        theme = "robbyrussell";
      };
      initExtra = ''
        export FZF_BASE=${pkgs.fzf}
        export ZSH_FZF_HISTORY_SEARCH_BIND='^r'
        export ZSH_FZF_HISTORY_SEARCH_FZF_ARG='+s +m -x -e --preview-window=hidden'
        export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=1
        source ${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh
      '';
    };
  };
}
