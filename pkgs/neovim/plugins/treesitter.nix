{vimPlugins}:
with vimPlugins; {
  plugins = [
    (nvim-treesitter.withPlugins (p: [
      p."tree-sitter-bash"
      p."tree-sitter-markdown"
      p."tree-sitter-nix"
      p."tree-sitter-python"
      p."tree-sitter-toml"
      p."tree-sitter-yaml"
    ]))
  ];
  lua = ''
    require'nvim-treesitter.configs'.setup {
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          scope_incremental = "grc",
          node_decremental = "grm",
        },
      },
      indent = {
        enable = true
      },
    }
  '';
}
