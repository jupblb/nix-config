require("zen-mode").setup({
  plugins = { kitty = { enabled = true } },
  window = { options = { signcolumn = "no" } }
})

vim.api.nvim_set_keymap('n', '<Leader>`', '<Cmd>ZenMode<CR>', { noremap = true, silent = true })
