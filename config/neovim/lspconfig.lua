local lspconfig = require("lspconfig")
local lsp_status = require("lsp-status")
local null_ls = require("null-ls")

-- Replace default signs
local signs = {
    Error = " ",
    Warning = " ",
    Hint = " ",
    Information = " "
}
for type, icon in pairs(signs) do
    local hl = "LspDiagnosticsSign" .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = ""})
end

-- Add border to the floating windows
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or {
        {"╭", "FloatBorder"}, {"─", "FloatBorder"}, {"╮", "FloatBorder"},
        {"│", "FloatBorder"}, {"╯", "FloatBorder"}, {"─", "FloatBorder"},
        {"╰", "FloatBorder"}, {"│", "FloatBorder"}
    }
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- null-ls setup
null_ls.config({
    sources = {
        null_ls.builtins.diagnostics.luacheck.with({
            extra_args = {'--globals', 'vim'}
        }), --
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.formatting.fish_indent,
        -- null_ls.builtins.formatting.google_java_format,
        null_ls.builtins.formatting.lua_format,
        null_ls.builtins.formatting.json_tool, --
        null_ls.builtins.formatting.shfmt
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

-- Setup
lspconfig.util.default_config = vim.tbl_extend("force",
                                               lspconfig.util.default_config, {
    capabilities = lsp_status.capabilities,
    flags = {debounce_text_changes = 150},
    on_attach = lsp_status.on_attach
})

local default_servers = {"bashls", "dockerls", "gopls", "null-ls", "rnix", "zk"}
for _, lsp in ipairs(default_servers) do lspconfig[lsp].setup({}) end

lspconfig.jsonls.setup({
    cmd = {"vscode-json-languageserver", "--stdio"},
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0})
            end
        }
    },
    settings = {json = {schemas = require("schemastore").json.schemas()}}
})

-- lspconfig.jsonnet_ls.setup({
--    single_file_support = true
-- })

lspconfig.pyright.setup({settings = {python = {pythonPath = "python3"}}})
