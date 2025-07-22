{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
/*
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
*/
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... } @inputs:
    let
      # Credit https://github.com/notusknot/dotfiles-nix/blob/main/flake.nix
      newSystem = hostname: system: pkgs:
        pkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = system;
          modules = [
            (./hosts + "/${hostname}/configuration.nix")
            (./hosts + "/${hostname}/hardware-configuration.nix")
            #home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
/*
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useUserPackages = true;
                useGlobalPkgs = true;
                users.kzrob = ./hosts + "/${hostname}/home.nix";
              };
*/
            }
          ];
        };
    in {
      nixosConfigurations = {
        acerp = newSystem "acerp" "x86_64-linux" inputs.nixpkgs;
      };
    };
}
