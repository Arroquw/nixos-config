_: {
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
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
    };
  };
}
