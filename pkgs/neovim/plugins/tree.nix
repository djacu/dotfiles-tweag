{vimPlugins}:
with vimPlugins; {
  plugins = [
    nvim-tree-lua
    nvim-web-devicons
  ];
  lua = ''
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    })

    require'nvim-web-devicons'.setup {
      -- your personnal icons can go here (to override)
      -- you can specify color or cterm_color instead of specifying both of them
      -- DevIcon will be appended to `name`
      override = {
        -- zsh = {
          -- icon = "",
          -- color = "#428850",
          -- cterm_color = "5",
        -- name = "Zsh"
        -- },
      };
      -- globally enable default icons (default to false)
      -- will get overriden by `get_icons` option
      default = true;
    }
  '';
}
