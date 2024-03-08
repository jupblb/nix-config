local telescope = require('telescope')
local builtin   = require('telescope.builtin')

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
telescope.load_extension('ui-select')
