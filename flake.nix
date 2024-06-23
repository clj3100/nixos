{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-master, home-manager, lanzaboote, ... }@inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system; 
        config.allowUnfree = true;
      };
      pkgs-master = import nixpkgs-master {
        inherit system;
        config.allowUnfree = true;
      };
    in
   {
    nixosConfigurations = {
      nixos16 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          {
          nixpkgs.overlays = [
            (final: prev: {
              master = pkgs-master;
            })
          ];
          }
          {
            users.users.trey.home = "/home/trey";
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.trey = import ./home;
            home-manager.extraSpecialArgs = { inherit inputs ;};

          }
          lanzaboote.nixosModules.lanzaboote
          (import ./laptop.nix )
        ];
        specialArgs = { inherit inputs ;};
      };
    };
  };
}
