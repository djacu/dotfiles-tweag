{ pkgs, ... }:

{
  programs.neovim.enable = true;
  programs.neovim.coc.enable = true;
  programs.neovim.plugins =
    with pkgs.vimPlugins;
    [
      coc-nvim
      vim-lastplace
      nvim-lspconfig
      telescope-nvim
      telescope-file-browser-nvim
      which-key-nvim
      (nvim-treesitter.withPlugins (p: [
	p."tree-sitter-bash"
	p."tree-sitter-markdown"
	p."tree-sitter-nix"
        p."tree-sitter-python"
	p."tree-sitter-toml"
	p."tree-sitter-yaml"
      ]))
    ];
}
