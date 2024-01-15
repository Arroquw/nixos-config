{ pkgs, ... }: {
  programs.starship = let flavour = "mocha";
  in {
    enable = true;
    settings = {
      palette = "catppuccin_${flavour}";

      sudo = { disabled = false; };

      # Icon changes
      git_branch.symbol = " ";
    } // builtins.fromTOML (builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "starship";
      rev = "5629d2356f62a9f2f8efad3ff37476c19969bd4f";
      sha256 = "nsRuxQFKbQkyEI4TXgvAjcroVdG+heKX5Pauq/4Ota0=";
    } + /palettes/${flavour}.toml));
  };
}
