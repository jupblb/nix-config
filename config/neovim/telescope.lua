local actions = require('telescope.actions')
local telescope = require('telescope')

telescope.setup{
  defaults = {
    mappings = { i = { ["<esc>"] = actions.close } },
--    layout_strategy = "vertical"
  }
}
telescope.load_extension('fzy_native')

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<Leader><Tab>', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>hc', '<cmd>Telescope command_history<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>hf', '<cmd>Telescope oldfiles<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>hj', '<cmd>Telescope marks<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>hs', '<cmd>Telescope search_history<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>s', '<cmd>Telescope live_grep<CR>', opts)

vim.api.nvim_set_keymap('n', '<Leader>gb', '<cmd>Telescope git_branches<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gc', '<cmd>Telescope git_commits<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gC', '<cmd>Telescope git_bcommits<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gf', '<cmd>Telescope git_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gs', '<cmd>Telescope git_status<CR>', opts)
