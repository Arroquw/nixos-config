{ pkgs, ... }: {

  xdg.configFile."nvim".source = pkgs.stdenv.mkDerivation {
    name = "NvChad";
    src = pkgs.fetchFromGitHub {
      owner = "NvChad";
      repo = "NvChad";
      rev = "e5f8a38ae3d6b3bedf68f29b0e96dad7a4ca2da5";
      hash = "sha256-P5TRjg603/7kOVNFC8nXfyciNRLsIeFvKsoRCIwFP3I=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/
      cd $out/
    '';
  };

  #cp -r ${./my_nvchad_config} $out/lua/custom
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
