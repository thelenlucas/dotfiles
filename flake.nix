{
  description = "My local system setup using flakes + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        ./hardware/laptop.nix

        { networking.hostName = "laptop"; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lucas = ./home/home.nix;
        }

      ];
    };

    nixosConfigurations.labtop = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./nixos/configuration.nix
        ./hardware/labtop.nix
	./nixos/server_power.nix

        { networking.hostName = "labtop"; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lucas = ./home/home.nix;
        }

      ];
    };
  };

}
