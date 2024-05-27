{ inputs, outputs, lib, config, nixvim, ... }:
let inherit (inputs.nix-colors) colorSchemes;
in {
  imports = [
    ./shell
    inputs.nix-colors.homeManagerModule
    inputs.nixvim.homeManagerModules.nixvim
  ] ++ (builtins.attrValues outputs.homeManagerModules);
  colorscheme = lib.mkDefault colorSchemes.tokyo-night-storm;

  programs = {
    home-manager.enable = true;
    git.enable = true;
    wlogout.enable = true;
  };

  home = {
    username = lib.mkDefault "justin";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";

    file = {
      ".config/rofi/rofi-network-manager.rasi".source =
        ../../scripts/rofi/share/rofi-network-manager.rasi;
      ".config/rofi/rofi-network-manager.conf".source =
        ../../scripts/rofi/share/rofi-network-manager.conf;
      ".config/rofi/style.rasi".source = ../../scripts/rofi/share/style.rasi;
      ".config/rofi/shared".source = ../../scripts/rofi/share/shared;
      "Desktop/wallpapers".source = ../../wallpapers;
      ".config/wlogout" = {
        source = ../../.config/wlogout;
        recursive = true;
        executable = true;
      };
      ".config/discord/settings.json" = {
        text = ''{ "SKIP_HOST_UPDATE": true }'';
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
