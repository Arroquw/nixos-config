{ ... }: {
  imports = [ ../default.nix ];

  programs = {
    git = {
      userName = "justinvson-pd";
      userEmail = "justin.van.son@prodrive-technologies.com";
    };
  };
}
