{
  description = "Hyprland+waybar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, hyprland, home-manager, ... }:
    let
      system = "x86_64-linux";
      buildSystem = { username, name }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { user = username; };
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
    in {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      nixosConfigurations = {
        lnxclnt2840 = buildSystem { name = "dell-laptop-work"; username = "jusson"; };
        NixOs-justin = buildSystem { name = "pc-i9_9900k-rtx3090"; username = "justin"; };
      };
    };
}
#nixos-23.11

