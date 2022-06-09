{
  wrapNeovim,
  neovim-unwrapped,
  vimPlugins,
}:
(wrapNeovim neovim-unwrapped {}).override {
  # viAlias = true;
  # vimAlias = true;
  configure = {
    packages.myVimPackages.start = with vimPlugins; [
      vim-lastplace
    ];
    customRC = builtins.readFile ./config.vim;
  };
}
