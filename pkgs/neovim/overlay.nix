{neovim-flake}: final: prev: {
  neovim = prev.callPackage ./neovim.nix {};
  neovim-nightly = prev.callPackage ./neovim.nix {
    neovim-unwrapped = neovim-flake.packages.${prev.system}.neovim;
  };
}
