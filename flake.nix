{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-colors.url = "github:misterio77/nix-colors";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.aquamarine.url = "github:hyprwm/aquamarine";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      pre-commit-hooks,
      nixvim,
      ...
    }:
    let
      inherit (self) outputs;
      lib = nixpkgs.lib // home-manager.lib;
      systems = [ "x86_64-linux" ];
      forEachSystem = f: lib.genAttrs systems (system: f system pkgsFor.${system});
      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
      hosts = {
        gecko = "justin";
        lnxclnt2840 = "jusson";
      };

      mkNixos =
        hostname: user:
        lib.nixosSystem {
          specialArgs = {
            inherit
              user
              self
              inputs
              outputs
              ;
          };
          modules = [
            ./hosts/${hostname}
            home-manager.nixosModules.default
            { imports = builtins.attrValues self.nixosModules; }
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                extraSpecialArgs = {
                  inherit
                    user
                    self
                    inputs
                    outputs
                    hostname
                    nixvim
                    ;
                };
                users.${user}.imports = [ ./home/hosts/${hostname}.nix ];
              };
            }
          ];
        };

      mkHome =
        hostname: user:
        lib.homeManagerConfiguration {
          pkgs = pkgsFor.x86_64-linux;
          modules = [
            ./home/hosts/${hostname}.nix
            ./home/common/nixpkgs.nix
          ];
          extraSpecialArgs = {
            inherit
              user
              self
              inputs
              outputs
              hostname
              nixvim
              ;
          };
        };

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
              settings = {
                ignore = [ "hardware-configuration.nix" ];
              };
            };
          };
        };
      };
    in
    {
      nixosModules = builtins.listToAttrs (
        map (x: {
          name = x;
          value = import (./modules/nixos + "/${x}");
        }) (builtins.attrNames (builtins.readDir ./modules/nixos))
      );

      homeModules = import ./modules/home-manager;
      checks = forEachSystem (system: pkgs: addPreCommitCheck system);
      packages = forEachSystem (system: pkgs: import ./pkgs { inherit pkgs; });
      devShells = forEachSystem (system: pkgs: import ./shell.nix { inherit self system pkgs; });

      formatter = forEachSystem (system: pkgs: pkgs.nixfmt);

      nixosConfigurations = lib.mapAttrs mkNixos hosts;

      homeConfigurations = lib.mapAttrs' (
        hostname: user: lib.nameValuePair "${user}@${hostname}" (mkHome hostname user)
      ) hosts;
    };
}
