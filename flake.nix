{
  description = "Hyprland+waybar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = { self, nixpkgs, hyprland, home-manager, flake-utils
    , pre-commit-hooks, ... }:
    let
      inherit (flake-utils.lib) eachDefaultSystem;
      system = "x86_64-linux";
      buildSystem = { username, name }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            user = username;
            inherit self;
          };
          modules = [
            ./hosts/${name}/configuration.nix
            hyprland.nixosModules.default
            {
              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };
            }
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { user = username; };
                users.${username} = import ./modules/home.nix;
              };
            }
          ];
        };
    in rec {
      nixosConfigurations = {
        lnxclnt2840 = buildSystem {
          name = "dell-laptop-work";
          username = "jusson";
        };
        NixOs-justin = buildSystem {
          name = "pc-i9_9900k-rtx3090";
          username = "justin";
        };
      };
    } // eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        formatter = pkgs.nixfmt;
        packages = import ./pkgs { inherit pkgs; };
        checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            deadnix.enable = true;
            statix.enable = true;
          };
          settings = {
            deadnix.edit = true;
            deadnix.noLambdaArg = true;
          };
        };
        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
        };
      });
}
#nixos-23.11

