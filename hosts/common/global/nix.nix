{ lib, ... }: {
  nix = {
    settings = {
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      # Keep the last 5 generations
      options = "--delete-older-than +5";
    };
  };
}
