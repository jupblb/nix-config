local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local plenary_ft = require('plenary.filetype')
local previewers = require('telescope.previewers')
local telescope = require('telescope')
local putils = require('telescope.previewers.utils')

plenary_ft.add_file('nix')

telescope.setup{
  defaults = {
    mappings = { i = { ["<esc>"] = actions.close } },
--    layout_strategy = "vertical"
  }
}

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<Leader><Tab>', '<cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<cmd>Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>s', '<cmd>Telescope live_grep<CR>', opts)

vim.api.nvim_set_keymap('n', '<Leader>gb', '<cmd>Telescope git_branches<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gc', '<cmd>Telescope git_commits<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gC', '<cmd>Telescope git_bcommits()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gs', '<cmd>Telescope git_status()<CR>', opts)
