local null_ls = require("null-ls")

if vim.fn.getcwd():find('/google/src/') ~= nil then
    return
end

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.fish,
        null_ls.builtins.diagnostics.markdownlint,
        null_ls.builtins.formatting.fish_indent,
        null_ls.builtins.formatting.jq,
        null_ls.builtins.formatting.shfmt.with({ extra_args = { '-i=4' } }),
    }
})

local commonmark = 'commonmark+footnotes+pipe_tables+task_lists+tex_math_dollars+yaml_metadata_block'

null_ls.register({
    method = null_ls.methods.FORMATTING,
    filetypes = { 'markdown' },
    generator = null_ls.generator({
        command = 'pandoc',
        args = function(params)
            local args = {
                '--columns=80', '-s', '-f', 'markdown', '-t', commonmark, '-'
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