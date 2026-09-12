{
  inputs,
  outputs,
  lib,
  config,
  ...
}:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  imports = [
    ./shell
    inputs.nix-colors.homeManagerModule
    inputs.nixvim.homeModules.nixvim
  ]
  ++ (builtins.attrValues outputs.homeModules);
  colorscheme = lib.mkDefault colorSchemes.tokyo-night-storm;

  programs = {
    home-manager.enable = true;
    git.enable = true;
    wlogout.enable = true;
  };
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Photos";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Video";
    setSessionVariables = true;
  };

  home = {
    # username is set per-host in home/hosts/<hostname>.nix
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    file = {
      "Desktop/wallpapers".source = ../../wallpapers;
      ".config/wlogout" = {
        source = ../../.config/wlogout;
        recursive = true;
        executable = true;
      };
    };
    shellAliases."v" = "nvim";
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      XDG_CACHE_HOME = "\${HOME}/.cache";
      XDG_CONFIG_HOME = "\${HOME}/.config";
      XDG_BIN_HOME = "\${HOME}/.local/bin";
      XDG_DATA_HOME = "\${HOME}/.local/share";
      GTK_USE_PORTAL = "1";
      NIXOS_XDG_OPEN_USE_PORTAL = "1";
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = lib.mkDefault "23.05";
  };

}
