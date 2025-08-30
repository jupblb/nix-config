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
    pickers = {
        file_browser = {
            git_status = false,
            hijack_netrw = true,
        },
        find_files   = {
            previewer     = false,
            layout_config = { horizontal = { width = 0.5 } }
        },
        oldfiles     = {
            cwd_only      = true,
            previewer     = false,
            layout_config = { horizontal = { width = 0.5 } }
        },
        pickers      = {
            previewer     = false,
            layout_config = { horizontal = { width = 0.5 } }
        },
    },
})

telescope.load_extension('file_browser')
telescope.load_extension('fzf')
telescope.load_extension('live_grep_args')
telescope.load_extension('lsp_handlers')
telescope.load_extension('ui-select')

vim.keymap.set('n', '<Leader><Tab>',
    function() builtin.buffers({ sort_mru = true }) end)
vim.keymap.set('n', '<Leader>/', builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<Leader>ld',
    function() builtin.diagnostics({ bufnr = 0 }) end)
vim.keymap.set('n', '<Leader>lD', builtin.diagnostics)
vim.keymap.set('n', '<Leader>e',
    function()
        telescope.extensions.file_browser.file_browser({
            path = '%:p:h',
            select_buffer = true
        })
    end)
vim.keymap.set('n', '<Leader>f', builtin.find_files)
vim.keymap.set('n', '<Leader>j', builtin.jumplist)
vim.keymap.set('n', '<Leader>?',
    telescope.extensions.live_grep_args.live_grep_args)
vim.keymap.set('n', '<Leader>`', builtin.marks)
vim.keymap.set('n', '<Leader>o',
    function() builtin.oldfiles({ cwd_only = true }) end)
vim.keymap.set('n', '<Leader><Space>', builtin.pickers)
vim.keymap.set('n', '<Leader>"', builtin.registers)

vim.api.nvim_create_autocmd('User', {
    pattern = 'TelescopePreviewerLoaded',
    callback = function() vim.opt_local.wrap = true end
})

require('zoekt').setup({})
vim.keymap.set('n', '<Leader>q', telescope.extensions.zoekt.zoekt)
