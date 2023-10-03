{
  description = "Hyprland+waybar";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; };

  outputs = { self, nixpkgs, hyprland, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
       inherit system;
       config.allowUnfree = true;
        };
    in {
      nixosConfigurations = {
	lnxclnt2840 = nixpkgs.lib.nixosSystem {
          inherit system;
	  specialArgs = {user = "jusson";};
          modules = [
	    ./hosts/dell-laptop-work/configuration.nix
            hyprland.nixosModules.default
            {
              programs.hyprland.enable = true;
              programs.hyprland.xwayland.enable=true;
            }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {user = "jusson";};
              home-manager.users.jusson = import ./modules/home.nix;
            }
          ];
	  specialArgs = { inherit nixpkgs; };
      };
      NixOs-justin = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = {user = "justin";};
	modules = [
	  ./hosts/pc-i9_9900k-rtx3090/configuration.nix
	  hyprland.nixosModules.default
          {
		programs.hyprland.enable = true;
		programs.hyprland.xwayland.enable = true;
	  }
	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.extraSpecialArgs = {user = "justin";};
	    home-manager.users.justin = import ./modules/home.nix;
	  }
	];
      };
    };
  };
}

#nixos-23.11





