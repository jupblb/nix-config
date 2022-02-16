local previewers = require('telescope.previewers')
local telescope = require('telescope')

require('neoclip').setup({default_register = '*'})

local custom_buffer_previewer = function(filepath, bufnr, opts)
    opts = opts or {}
    if opts.use_ft_detect == nil then
        local ft = require('plenary.filetype').detect(filepath)
        if ft == 'yaml' then
            opts.use_ft_detect = false
            require('telescope.previewers.utils').regex_highlighter(bufnr, ft)
        end
    end
    previewers.buffer_previewer_maker(filepath, bufnr, opts)
end

telescope.setup {
    defaults = {
        buffer_previewer_maker = custom_buffer_previewer,
        mappings = {i = {["<esc>"] = require('telescope.actions').close}},
        layout_config = {
            flex = {flip_columns = 160},
            vertical = {preview_height = 0.5}
        },
        layout_strategy = "flex"
    },
    pickers = {
        find_files = {
            previewer = false,
            layout_config = {horizontal = {width = 0.5}}
        },
        oldfiles = {
            cwd_only = true,
            previewer = false,
            layout_config = {horizontal = {width = 0.5}}
        }
    }
}

telescope.load_extension('fzf')
telescope.load_extension('lsp_handlers')
telescope.load_extension('neoclip')
telescope.load_extension('vim_bookmarks')
