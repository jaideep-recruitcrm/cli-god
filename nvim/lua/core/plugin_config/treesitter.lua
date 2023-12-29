require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "ruby", "vim" },

  syn_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
