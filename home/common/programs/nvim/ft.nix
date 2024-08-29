_:
let
  listTabOf2 = [ "nix" "js" "ts" "json" "yaml" "bash" "sh" "html" ];
  listTabOf4 = [ "c" "py" "go" "java" "cpp" "cs" "php" "lua" "sql" "make" ];
  listExpand4 = [ "py" "sql" ];
  tabOf2 = lang: {
    opts = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
      softtabstop = 2;
    };
  };
  tabOf4 = lang: {
    opts = {
      expandtab = false;
      shiftwidth = 4;
      tabstop = 4;
      softtabstop = 4;
    };
  };
  # Maps the above 2 sets to each of the file types described in the lists
  result1 = builtins.listToAttrs (map (lang: {
    name = "ftplugin/" + lang + ".lua";
    value = tabOf2 lang;
  }) listTabOf2);
  result2 = builtins.listToAttrs (map (lang: {
    name = "ftplugin/" + lang + ".lua";
    value = if builtins.elem lang listExpand4 then
      (tabOf4 lang) // { opts.expandtab = true; }
    else
      tabOf4 lang;
  }) listTabOf4);
in { files = result1 // result2; }

