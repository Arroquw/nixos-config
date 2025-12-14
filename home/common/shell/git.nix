{ pkgs, ... }: {
  home.packages = with pkgs; [ gitflow gitui ];

  programs.git = {
    enable = true;
    package = pkgs.git;
    extraConfig = {
      merge.tool = "vscode";
      diff.tool = "vscode";
      core.editor = "vim";
      mergeTool = {
        keepBackup = false;
        vscode.cmd = "code --wait --new-window --diff $LOCAL $REMOTE";
      };
    };
    aliases = {
      co = "checkout";
      br = "branch";
      st = "status --short --branch";
      sts = "status";
      unstage = "reset HEAD -- ";
      rh = "reset --hard";
      a = "add .";
      cam = "commit --amend";
      camn = "commit --amend --no-edit";
      cm = "commit -m";
      cb = "checkout -B";
      alias = "config --get-regexp ^alias\\.";
      ec = "config --global -e";
      pushu = "!git push -u origin `git symbolic-ref --short HEAD`";
      cauthor = "commit --amend --reset-author --no-edit";
      logdiff = "log --pretty=oneline HEAD..";
      slog = "log --pretty=oneline";
      hist =
        "log --pretty=format:'%C(yellow)[%ad]%C(reset) %C(green)[%h]%C(reset) | %C(red)%s %C(bold red){{%an}}%C(reset) %C(blue)%d%C(reset)' --graph --date=short";
    };
  };
}
