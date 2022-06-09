{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/1.4.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = 
    {
      self,
      nixpkgs, 
      nixpkgs-wayland,
      home-manager,
      neovim-flake,
      alejandra,
      nix-colors
    }:
    let
      system = "x86_64-linux";

      overlays = [
        nixpkgs-wayland.overlay
        (import ./pkgs/neovim/overlay.nix { inherit neovim-flake; })
      ];

      pkgs = import nixpkgs {
        inherit system overlays;
        config = {
          allowUnfree = true;
        };
      };

      inherit (nixpkgs) lib;

      my-colors = import ./lib/colors.nix { inherit lib; };
    in
    {
      # formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      overlays.default = overlays;
      packages.${system} = {
        neovim-nightly = pkgs.neovim-nightly;
      };

      nixosConfigurations = {
        tweag-laptop = lib.nixosSystem {
          inherit system;

          specialArgs = { inherit nix-colors my-colors; };

          modules = [
            home-manager.nixosModules.home-manager
            (import ./system/configuration.nix)

            ({ pkgs, ... }: {
              environment.systemPackages = with pkgs; [
                alejandra.defaultPackage.${system}
                neovim-nightly
              ];
            })

            ({ ... }: {
              system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
              nix.registry.nixpkgs.flake = nixpkgs;
              nix.extraOptions = ''
                trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA=
                substituters = https://cache.nixos.org/ https://nixpkgs-wayland.cachix.org/
              '';
              nixpkgs = { inherit overlays; };

              # Required since swaylock is installed via home-manager.
              security.pam.services.swaylock = { };

              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.bakerdn = import ./users/bakerdn/home.nix;
              home-manager.extraSpecialArgs = {
                inherit nix-colors my-colors;
              };
            })
          ];

        };
      };
    };
}
