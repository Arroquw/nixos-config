# Shell for bootstrapping flake-enabled nix and other tooling
{ self, system, pkgs ?
# If pkgs is not defined, instanciate nixpkgs from locked commit
  let
    lock =
      (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in import nixpkgs { overlays = [ ]; }, ... }: {
    default = pkgs.mkShell {
      NIX_CONFIG =
        "extra-experimental-features = nix-command flakes repl-flake";
      inherit (self.checks.${system}.pre-commit-check) shellHook;
      nativeBuildInputs = with pkgs; [
        nix
        home-manager
        git
        statix
        alejandra

        sops
        ssh-to-age
        gnupg
        age
      ];
    };
  }
