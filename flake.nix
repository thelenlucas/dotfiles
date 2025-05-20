{
  description = "First pass at my system.";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/release-25.05";
    helix.url = "github:helix-editor/helix/master";
    probe-rs-rules.url = "github:jneem/probe-rs-rules";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, helix, probe-rs-rules, home-manager, ... }:
    let system = "x86_64-linux";
    in {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          probe-rs-rules.nixosModules.${system}.default

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.lucas = import ./home.nix;
          }
        ];
      };
    };
}
