local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.code_actions.statix,
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.diagnostics.opacheck,
        null_ls.builtins.diagnostics.statix,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.buildifier,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.latexindent.with({ filetypes = { 'bib', 'tex' } }),
        null_ls.builtins.formatting.shfmt.with({ extra_args = { '-i=4' } }),
        null_ls.builtins.formatting.rego,
    }
})

null_ls.register({
    method = null_ls.methods.FORMATTING,
    filetypes = { 'markdown' },
    generator = null_ls.generator({
        command = 'pandoc',
        args = function(params)
            local args = {
                '--columns=80', '-s', '-f', 'markdown', '-t',
                'markdown-simple_tables-raw_attribute', '-'
            }

            if string.find(params.bufname, "jupblb/Documents") then
                table.insert(args, "--reference-links")
            end

            return args
        end,
        on_output = function(params, done)
            return done({ { text = params.output } })
        end,
        to_stdin = true
    })
})
