{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-21.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      };

      inherit (nixpkgs) lib;

    in
    {
      homeManagerConfigurations = {
        bakerdn = home-manager.lib.homeManagerConfiguration {
          inherit system pkgs;

          username = "bakerdn";
          homeDirectory = "/home/bakerdn";

          # TODO - look at making stateVersion = pkgs.lib.trivial.release;
          stateVersion = "21.11";

          configuration = {
            imports = [
              ./users/bakerdn/home.nix
            ];
          };
        };
      };

      nixosConfigurations = {
        tweag-laptop = lib.nixosSystem {
          inherit system;

          modules = [
            ./system/configuration.nix
          ];
        };
      };
    };
}
