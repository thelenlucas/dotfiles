{
  description = "My local system setup using flakes + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    nix-topology.url = "github:oddlama/nix-topology";
    nix-topology.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix = { url = "github:Mic92/sops-nix"; };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, flake-utils, nix-topology, sops-nix }:
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          ./hardware/laptop.nix
          nix-topology.nixosModules.default

          { networking.hostName = "laptop"; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lucas = ./home/home.nix;
          }

          sops-nix.nixosModules.sops

        ];
      };

      nixosConfigurations.labtop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          ./hardware/labtop.nix
          ./nixos/server_power.nix
          ./nixos/k3s.nix
          nix-topology.nixosModules.default

          { networking.hostName = "labtop"; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.lucas = ./home/home.nix;
          }

          sops-nix.nixosModules.sops
        ];
      };
    } // flake-utils.lib.eachDefaultSystem (system: rec {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nix-topology.overlays.default ];
      };

      topology = import nix-topology {
        inherit pkgs;
        modules = [
          ./topology.nix
          { nixosConfigurations = self.nixosConfigurations; }
        ];
      };
    });
}
