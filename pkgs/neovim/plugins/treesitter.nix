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
    nvim-ts-rainbow
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
      -- nvim-ts-rainbow
      rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
      },
    }
  '';
}
