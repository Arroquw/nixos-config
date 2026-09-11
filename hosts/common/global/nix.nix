{ lib, ... }:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      # Keep generations from the last 30 days (plus one older rollback anchor).
      options = "--delete-older-than 30d";
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };
}
