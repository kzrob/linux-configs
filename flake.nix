{
  description = "NixOS flake configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... } @inputs: {
    let
      # Credit https://github.com/notusknot/dotfiles-nix/blob/main/flake.nix
      newSystem = hostname: system: pkgs:
        pkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = system;
          modules = [
            ./hosts + "/${hostname}/configuration.nix"
            ./hosts + "/${hostname}/hardware-configuration.nix"
            home-manager.nixosModules.home-manager
            {
              networking.hostName = hostname;
              home-manager = {
                extraSpecialArgs = { inherit inputs; };
                useUserPackages = true;
                useGlobalPkgs = true;
                users.kzrob = ./hosts + "/${hostname}/home.nix";
              };
            }
          ];
        };
    in {
      acerp = newSystem "acerp" "x86_64-linux" inputs.nixpkgs;
    };

    /*
    nixpkgs.config.allowUnfree = true;

    # change to nixosConfigurations.HOSTNAME
    nixosConfigurations.acerp = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      system = "x86_64-linux";
      modules = [
        ./hosts/acerp/configuration.nix
        home-manager.nixosModules.default
      ];
    };
    */
  }
}
