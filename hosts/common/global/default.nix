{ lib, pkgs, ... }: {
  imports = [
    #    inputs.home-manager.nixosModules.home-manager
    ./acme.nix
    ./nix.nix
    ./fonts.nix
    ./locale.nix
    ./openssh.nix
    ./podman.nix
    ./sops.nix
    ./zsh.nix
  ];

  #  home-manager.extraSpecialArgs = {inherit inputs outputs;};

  nixpkgs = {
    overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
  };

  environment = {
    shells = with pkgs; [ zsh ];
    variables = { EDITOR = "vim"; };
    loginShellInit = ''
      if [ -e $HOME/.profile ]
      then
        . $HOME/.profile
      fi
    '';
    etc."xdg/user-dirs.defaults".text = ''
      DESKTOP=$HOME/Desktop
      DOWNLOAD=$HOME/Downloads
      TEMPLATES=$HOME/Templates
      PUBLICSHARE=$HOME/Public
      DOCUMENTS=$HOME/Documents
      MUSIC=$HOME/Music
      PICTURES=$HOME/Photos
      VIDEOS=$HOME/Video
    '';

    systemPackages = with pkgs; [ vim git ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  boot.supportedFilesystems = [ "ntfs" ];

  hardware = { bluetooth.enable = true; };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "23.05"; # Did you read the comment?
}
