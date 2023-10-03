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
      user = "jusson";
      buildSystem = { name }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit user; };
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
                extraSpecialArgs = { inherit user; };
                users.${user} = import ./modules/home.nix;
              };
            }
          ];
        };
    in {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
      nixosConfigurations = {
        lnxclnt2840 = buildSystem { name = "dell-laptop-work"; };
        NixOs-justin = let user = "justin";
        in buildSystem { name = "pc-i9_9900k-rtx3090"; };
      };
    };
}
#nixos-23.11

