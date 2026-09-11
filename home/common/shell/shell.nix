_: {
  programs = {
    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      historyWidget.options = [
        "--no-sort"
        "--exact"
      ];
    };

    pay-respects = {
      enable = true;
      enableZshIntegration = true;
    };

    bash.enable = true;

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
    };
  };
}
