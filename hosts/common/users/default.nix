{
  config,
  pkgs,
  user,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    users.${user} = {
      isNormalUser = true;
      description = "Justin van Son";
      # Host-specific groups are appended from the host's own module.
      extraGroups = [
        "networkmanager"
        "wheel"
        "plugdev"
        "kvm"
        "qemu-libvirtd"
        "libvirtd"
        "pipewire"
      ];
      hashedPasswordFile = config.sops.secrets."password-${user}".path;
    };
  };

  # Referenced by extraGroups above; nothing else creates it. The dediprog
  # udev rules (registered on the work host) hand SF100/EM100 devices to it.
  users.groups.plugdev = { };

  sops.secrets."password-${user}" = {
    sopsFile = ../secrets.yaml;
    neededForUsers = true;
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
      python3
    ];
  };

  security.pam.services = {
    hyprlock.text = "auth include login";
    greetd.enableGnomeKeyring = true;
  };
}
