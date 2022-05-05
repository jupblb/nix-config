local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.diagnostics.fish,
        -- https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md
        null_ls.builtins.diagnostics.markdownlint.with({
            extra_args = {
                '--disable', 'MD007', 'MD012', 'MD013', 'MD030', 'MD034'
            }
        }), --
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.statix,
        null_ls.builtins.formatting.buildifier,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.shfmt.with({extra_args = {'-i=4'}})
    }
})

null_ls.register({
    method = null_ls.methods.FORMATTING,
    filetypes = {'markdown'},
    generator = null_ls.generator({
        command = 'pandoc',
        args = {
            '-f', 'markdown', '-s', '-t', 'markdown-simple_tables',
            '--columns=80', '-'
        },
        on_output = function(params, done)
            return done({{text = params.output}})
        end,
        to_stdin = true
    })
})
