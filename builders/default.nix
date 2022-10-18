{pkgs, ...}: let
  inherit (pkgs.lib) concatStringsSep mapAttrsToList;

  nixExtraOptions = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "tweag-monad-bayes.cachix.org-1:tmmTZ+WvtUMpYWD4LAkfSuNKqSuJyL3N8ZVm/qYtqdc="
      "tweag-wasm.cachix.org-1:Eu5eBNIJvleiWMEzRBmH3/fzA6a604Umt4lZguKtAU4="
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://nixpkgs-wayland.cachix.org/"
      "https://tweag-monad-bayes.cachix.org"
      "https://tweag-wasm.cachix.org"
    ];
    builders-use-substitutes = [
      "true"
    ];
  };

  /*
  Takes an attrset name value pair and where the value is a list of strings. The list
  is concatenated with a space. The name is set equal to this result in a string.

  Type:
    joinExtraOptionValues :: a -> b -> String

  Example:
    joinExtraOptionValues
      "example"
      ["ex1" "ex2" "ex3"]
    => "example = ex1 ex2 ex3"
  */
  joinExtraOptionValues = name: value: name + " = " + (pkgs.lib.concatStringsSep " " value);

  /*
  Takes an attrset where the values are lists of strings and creates nix extraOptions.
  The values are concatenated with a space, set equal to the name in a string, and
  applied to all the attributes creating a list of strings. The result is concatenated
  with newlines.

  Type:
    mkNixExtraOptions :: AttrSet -> String

  Example:
    mkNixExtraOptions
      {
        keys = [
          "cache.nixos.org-1:1234567="
          "tweag.cachix.org-1:abcdef0="
        ];
        subs = [
          "https://cache.nixos.org/"
          "https://tweag.cachix.org/"
        ];
      }
    => ''
      keys = cache.nixos.org-1:1234567= tweag.cachix.org-1:abcdef0=
      subs = https://cache.nixos.org/ https://tweag.cachix.org/
    ''

  */
  mkNixExtraOptions = options:
    pkgs.lib.concatStringsSep "\n" (pkgs.lib.mapAttrsToList joinExtraOptionValues options);
in {
  nix.extraOptions = mkNixExtraOptions nixExtraOptions;
  nix.settings.trusted-users = ["@wheel"]; # or just your username

  nix.buildMachines = [
    # tweag remote builders
    {
      hostName = "build01.tweag.io";
      maxJobs = 24;
      sshUser = "nix";
      sshKey = "/root/.ssh/id-tweag-builder";
      system = "x86_64-linux";
      supportedFeatures = ["benchmark" "big-parallel" "kvm"];
    }
    {
      hostName = "build02.tweag.io";
      maxJobs = 24;
      sshUser = "nix";
      sshKey = "/root/.ssh/id-tweag-builder";
      systems = ["aarch64-darwin" "x86_64-darwin"];
      supportedFeatures = ["benchmark" "big-parallel"];
    }
  ];
}
