{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hardware.url = "github:nixos/nixos-hardware";
    impermanence.url = "github:nix-community/impermanence";
    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "github:hyprwm/hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprwm-contrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

  };

  outputs = { self, nixpkgs, hyprland, home-manager, flake-utils
    , pre-commit-hooks, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (flake-utils.lib) eachDefaultSystem;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" "aarch64-linux" ];
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });
    in rec {
      inherit lib;
      homeManagerModules = import ./modules/home-manager;

      nixosConfigurations = {
        # Work laptop
        lnxclnt2840 = lib.nixosSystem {
          modules = [
            ./hosts/dell-laptop-work/configuration.nix
            hyprland.nixosModules.default
            {
              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };
            }
          ];
          specialArgs = {
            user = "jusson";
            inherit self inputs outputs;
          };
        };
        # Main desktop
        NixOs-justin = lib.nixosSystem {
          modules = [
            ./hosts/pc-i9_9900k-rtx3090/configuration.nix
            hyprland.nixosModules.default
            {
              programs.hyprland = {
                enable = true;
                xwayland.enable = true;
              };
            }
          ];
          specialArgs = {
            user = "justin";
            inherit self inputs outputs;
          };
        };
      };

      homeConfigurations = {
        # Desktops
        "jusson@lnxclnt2840" = lib.homeManagerConfiguration {
          modules = [ ./home/dell-laptop-work ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            user = "jusson";
            users."jusson" = import home/dell-laptop-work;
            inherit inputs outputs;
          };
        };
        "justin@NixOs-justin" = lib.homeManagerConfiguration {
          modules = [ ./home/pc-i9_9900k-rtx3090 ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            user = "justin";
            inherit inputs outputs;
          };
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
