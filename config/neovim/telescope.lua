local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local previewers = require('telescope.previewers')
local telescope = require('telescope')

telescope.setup {
  defaults = {
    mappings = { i = { ["<esc>"] = actions.close } },
    layout_strategy = "flex",
    layout_defaults = {
      flex = { flip_columns = 160 },
      vertical = { preview_height = 0.5 }
    }
  },
  extensions = {
    fzf_writer = { use_highlighter = true },
    fzy_native = { override_generic_sorter = true }
  }
}
telescope.load_extension('fzy_native')

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<Leader><CR>', '<Cmd>Telescope file_browser hidden=true<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader><Tab>', '<Cmd>Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>/', '<Cmd>Telescope current_buffer_fuzzy_find<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>f', '<Cmd>lua require("telescope").extensions.fzf_writer.files()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>h', '<Cmd>Telescope oldfiles<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>m', '<Cmd>Telescope marks<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>s', '<Cmd>lua require("telescope").extensions.fzf_writer.grep()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>S', '<Cmd>lua require("telescope").extensions.fzf_writer.staged_grep()<CR>', opts)

delta_git_commits = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer {
    get_command = function(entry)
      return {
        'git', '-c', 'delta.side-by-side=false', '-c', 'delta.paging=never',
        'diff', entry.value .. '^!'
      }
    end
  }

  builtin.git_commits(opts)
end

delta_git_bcommits = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer {
    get_command = function(entry)
      return {
        'git', '-c', 'delta.side-by-side=false', '-c', 'delta.paging=never',
        '-c', 'delta.file-style=omit', 'diff', entry.value .. '^!', '--',
        opts.path
      }
    end
  }

  builtin.git_bcommits(opts)
end

delta_git_status = function(opts)
  opts = opts or {}
  opts.previewer = previewers.new_termopen_previewer {
    get_command = function(entry)
      return {
        'git', '-c', 'delta.side-by-side=false', '-c', 'delta.paging=never',
        '-c', 'delta.file-style=omit', 'diff', '--', entry.value
      }
    end
  }

  builtin.git_status(opts)
end

vim.api.nvim_set_keymap('n', '<Leader>gb', '<Cmd>Telescope git_branches<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gc', '<Cmd>lua delta_git_commits()<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gC', '<Cmd>lua delta_git_bcommits({path=vim.fn.expand("%:p")})<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gf', '<Cmd>Telescope git_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<Leader>gs', '<Cmd>lua delta_git_status()<CR>', opts)
