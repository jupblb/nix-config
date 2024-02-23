local telescope = require('telescope')
local builtin   = require('telescope.builtin')

require('neoclip').setup({ default_register = '*' })

telescope.setup({
    defaults = {
        cache_picker          = { num_pickers = -1, limit_entries = 0 },
        dynamic_preview_title = true,
        mappings              = {
            i = { ['<esc>'] = require('telescope.actions').close }
        },
        layout_config         = {
            flex     = { flip_columns = 160 },
            vertical = { preview_height = 0.5 }
        },
        layout_strategy       = 'flex',
        path_display          = { 'truncate' },
        wrap_results          = true,
    },
    extensions = {
        undo = {
            layout_strategy = 'vertical',
            mappings        = {
                i = { ['<CR>'] = require('telescope-undo.actions').restore, },
            },
        },
    },
    pickers = {
        find_files = {
            previewer     = false,
            layout_config = { horizontal = { width = 0.5 } }
        },
        oldfiles   = {
            cwd_only      = true,
            previewer     = false,
            layout_config = { horizontal = { width = 0.5 } }
        },
        pickers    = {
            previewer     = false,
            layout_config = { horizontal = { width = 0.5 } }
        },
    },
})

telescope.load_extension('fzf')
telescope.load_extension('lsp_handlers')
telescope.load_extension('neoclip')
telescope.load_extension('ui-select')
telescope.load_extension('undo')

-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
local is_inside_work_tree = nil
vim.keymap.set('n', '<Leader>f', function()
    if is_inside_work_tree == nil then
        vim.fn.system("git rev-parse --is-inside-work-tree")
        is_inside_work_tree = vim.v.shell_error == 0
    end

    if is_inside_work_tree then
        builtin.git_files({})
    else
        builtin.find_files({})
    end
end, {})
vim.keymap.set('n', '<Leader>F', builtin.find_files, {})
