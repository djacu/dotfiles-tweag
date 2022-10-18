{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    /*
        The Nix User Repository (NUR) is community-driven meta repository for
     Nix packages. It provides access to user repositories that contain package
     descriptions (Nix expressions) and allows you to install packages by
     referencing them via attributes. In contrast to Nixpkgs, packages are
     built from source and are not reviewed by any Nixpkgs member.
     */
    nur.url = "github:nix-community/NUR";

    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    nix-colors.url = "github:misterio77/nix-colors";

    flake-utils.url = "github:numtide/flake-utils";

    sway-tools.url = "github:smasher164/sway-tools";
    sway-tools.flake = true;
    sway-tools.inputs.nixpkgs.follows = "nixpkgs";
    sway-tools.inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-wayland,
    home-manager,
    nur,
    neovim-flake,
    alejandra,
    nix-colors,
    flake-utils,
    sway-tools,
  }: let
    system = "x86_64-linux";

    overlays = [
      nixpkgs-wayland.overlay
      (import ./pkgs/neovim/overlay.nix {inherit neovim-flake;})
      nur.overlay # adds nur to nixpkgs
    ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    inherit (nixpkgs) lib;
  in {
    # formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    overlays.default = overlays;
    packages.${system} = {
      inherit (pkgs) neovim neovim-nightly;
    };

    nixosConfigurations = {
      tweag-laptop = lib.nixosSystem {
        inherit system;

        specialArgs = {inherit nix-colors;};

        modules = [
          home-manager.nixosModules.home-manager
          (import ./system/configuration.nix)
          (import ./services/pipewire.nix)
          (import ./builders)

          ({pkgs, ...}: {
            environment.systemPackages = with pkgs; [
              alejandra.defaultPackage.${system}
              neovim
              gh
              nix-doc
              sway-tools.packages.${system}.pw-volume
            ];
          })

          ({...}: {
            system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
            nix.registry.nixpkgs.flake = nixpkgs;
            nixpkgs = {
              inherit overlays;
              config.allowUnfree = true;
            };

            # Required since swaylock is installed via home-manager.
            security.pam.services.swaylock = {};

            # The previous update broke a lot of things. Possibly due to nixpkgs-wayland.
            # https://github.com/nix-community/nixpkgs-wayland/issues/346
            # Nope it was because of a change in nixpkgs:
            # https://github.com/NixOS/nixpkgs/pull/186028
            # TODO - disable this if home-manager fixes this
            # https://github.com/nix-community/home-manager/issues/3160
            security.polkit.enable = true;

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
