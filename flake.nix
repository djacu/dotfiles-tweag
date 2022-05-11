{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = 
    {
      self,
      nixpkgs, 
      nixpkgs-wayland,
      home-manager,
      nix-colors
    }:
    let
      system = "x86_64-linux";

      overlays = [
        nixpkgs-wayland.overlay
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };

      inherit (nixpkgs) lib;

    in
    {
      nixosConfigurations = {
        tweag-laptop = lib.nixosSystem {
          inherit system;

          specialArgs = { inherit nix-colors; };

          modules = [
            home-manager.nixosModules.home-manager
            (import ./system/configuration.nix)
            ({ ... }: {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
              nix.extraOptions = ''
                trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=
                substituters = https://cache.nixos.org/ https://nixpkgs-wayland.cachix.org/
              '';
              nixpkgs = { inherit overlays; };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bakerdn = import ./users/bakerdn/home.nix;
              home-manager.extraSpecialArgs = {
                inherit nix-colors;
              };
            })
          ];

        };
      };
    };
}
