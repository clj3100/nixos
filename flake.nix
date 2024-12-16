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
              openrgb = prev.openrgb.overrideAttrs (_: { src = final.fetchFromGitLab {
                owner = "CalcProgrammer1";
                repo = "OpenRGB";
                rev = "e2a0032657bc5743ca064271fcc3c26a81a8decb";
                hash = "sha256-H5wxVTJgHiJzOSTWrenLYn4iNLIX5wl+kUgyAkPDyBs=";
              };});
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
          (import ./hosts/nixos16 )
        ];
        specialArgs = { inherit inputs ;};
      };
      desktoparm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
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
            (import ./hosts/desktoparm)
          ];
      };
      gaming-desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
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
            (import ./hosts/gaming-desktop)
          ];
      };
    };
  };
}
