require('nvim-tree').setup({
    actions = {
        expand_all = {
            max_folder_discovery = 100,
        },
    },
    diagnostics = {
        enable = true,
        icons = { error = '', hint = '', warning = '' },
        show_on_dirs = true,
    },
    renderer = {
        group_empty = true,
        highlight_git = true,
        icons = {
            glyphs = {
                default = '',
                folder = {
                    default = '',
                    empty = '',
                    empty_open = '',
                    open = '',
                    symlink = '',
                    symlink_open = '',
                },
                git = {
                    deleted = '',
                    ignored = '',
                    renamed = '',
                    staged = '',
                    unmerged = '',
                    unstaged = '',
                    untracked = '',
                },
                symlink = '',
            },
            padding = '  ',
            show = {
                folder_arrow = false,
            },
        },
    },
    view = {
        adaptive_size = true,
        mappings = {
            list = {
                { key = "<C-e>", action = "" },
            },
        },
        width = 42,
    },
})
