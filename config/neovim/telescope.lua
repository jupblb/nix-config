local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local plenary_ft = require('plenary.filetype')
local previewers = require('telescope.previewers')
local telescope = require('telescope')

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

local delta = previewers.new_termopen_previewer {
  get_command = function(entry)
    if entry.status == '??' or 'A ' then
      return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value }
    end
    return { 'git', '-c', 'core.pager=delta', '-c', 'delta.side-by-side=false', 'diff', entry.value .. '^!' }
  end
}

delta_git_commits = function(opts)
  opts = opts or {}
  opts.previewer = delta
  builtin.git_commits(opts)
end

delta_git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = delta
  builtin.git_bcommits(opts)
end

delta_git_status = function(opts)
  opts = opts or {}
  opts.previewer = delta
  builtin.git_status(opts)
end

vim.api.nvim_set_keymap('n', '<Leader>gb', '<cmd>Telescope git_branches<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gc', '<cmd>lua delta_git_commits()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gC', '<cmd>lua delta_git_bcommits()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gs', '<cmd>lua delta_git_status()<CR>', opts)
