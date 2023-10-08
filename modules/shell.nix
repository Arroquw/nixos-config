{ programs, ... }: {
  programs.bash.shellAliases = {
    switch = "sudo nixos-rebuild switch --flake .#";
    switchu = "sudo nixos-rebuild switch --upgrade --flake .#";
    clean = "sudo nix-collect-garbage -d";
    cleanold = "sudo nix-collect-garbage --delete-old";
    cleanboot = "sudo /run/current-system/bin/switch-to-configuration boot";
  };
  #starship
  programs.starship.enable = true;
}
