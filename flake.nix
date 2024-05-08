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
    nur = { url = "github:nix-community/nur"; };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = { url = "github:pta2002/nixvim"; };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, pre-commit-hooks, nur, ... }:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" ];
      forEachSystem = f:
        lib.genAttrs systems (system: f system pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        });
      nur-no-pkgs =
        import nur { nurpkgs = import nixpkgs { system = "x86_64-linux"; }; };
      addPreCommitCheck = system: {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt.enable = true;
            nil.enable = true;
            shellcheck.enable = true;
            black.enable = true;
            deadnix = {
              enable = true;
              settings = {
                edit = true;
                noLambdaArg = true;
                exclude = [ "hardware-configuration.nix" ];
              };
            };
            statix = {
              enable = true;
              settings = { ignore = [ "hardware-configuration.nix" ]; };
            };
          };
        };
      };
    in {
      nixosModules = builtins.listToAttrs (map (x: {
        name = x;
        value = import (./modules/nixos + "/${x}");
      }) (builtins.attrNames (builtins.readDir ./modules/nixos)));

      homeManagerModules = import ./modules/home-manager;
      checks = forEachSystem (system: pkgs: addPreCommitCheck system);
      packages = forEachSystem (system: pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem
        (system: pkgs: import ./shell.nix { inherit self system pkgs; });

      formatter = forEachSystem (syste4m: pkgs: pkgs.nixfmt);

      nixosConfigurations = {
        # Main desktop
        gecko = lib.nixosSystem {
          modules = [
            ./hosts/gecko
            { imports = builtins.attrValues self.nixosModules; }
            { nixpkgs.overlays = [ nur.overlay ]; }
          ];
          specialArgs = {
            inherit self inputs outputs;
            user = "justin";
          };
        };
        # Work laptop
        lnxclnt2840 = lib.nixosSystem {
          modules = [
            ./hosts/lnxclnt2840
            { imports = builtins.attrValues self.nixosModules; }
          ];
          specialArgs = {
            inherit self inputs outputs;
            user = "jusson";
          };
        };
      };

      homeConfigurations = {
        # Desktops
        "jusson@lnxclnt2840" = lib.homeManagerConfiguration {
          modules = [ ./home/jusson/lnxclnt2840.nix ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit self inputs outputs;
            user = "jusson";
          };
        };
        "justin@gecko" = lib.homeManagerConfiguration {
          modules =
            [ ./home/justin/gecko.nix { nixpkgs.overlays = [ nur.overlay ]; } ];
          pkgs = pkgsFor.x86_64-linux;
          extraSpecialArgs = {
            inherit nur-no-pkgs self inputs outputs;
            user = "justin";
          };
        };
      };
    };
}
