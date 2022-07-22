local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.statix,
        null_ls.builtins.formatting.buildifier,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.shfmt.with({ extra_args = { '-i=4' } })
    }
})

null_ls.register({
    method = null_ls.methods.FORMATTING,
    filetypes = { 'markdown' },
    generator = null_ls.generator({
        command = 'pandoc',
        args = {
            '-f', 'markdown', '-s', '-t', 'markdown-simple_tables',
            '--columns=80', '-'
        },
        on_output = function(params, done)
            return done({ { text = params.output } })
        end,
        to_stdin = true
    })
})

-- https://github.com/jose-elias-alvarez/null-ls.nvim/issues/896#issuecomment-1146919411
vim.api.nvim_create_user_command("NullLsToggle", function() require("null-ls").toggle({}) end, {})
