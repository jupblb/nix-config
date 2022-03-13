local lspconfig = require("lspconfig")
local lsp_status = require("lsp-status")

-- Disable virtual text for errors
vim.diagnostic.config({virtual_text = false})

-- Replace default signs
local signs = {
    Error = ' ',
    Warning = ' ',
    Hint = ' ',
    Information = ' '
}
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end

-- Add border to the floating windows
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or {
        {'╭', 'FloatBorder'}, {'─', 'FloatBorder'}, {'╮', 'FloatBorder'},
        {'│', 'FloatBorder'}, {'╯', 'FloatBorder'}, {'─', 'FloatBorder'},
        {'╰', 'FloatBorder'}, {'│', 'FloatBorder'}
    }
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Setup
_G.lsp_attach = function(client)
    vim.api.nvim_buf_set_option(0, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
    lsp_status.on_attach(client)
end

lspconfig.util.default_config = vim.tbl_extend('force',
                                               lspconfig.util.default_config, {
    capabilities = lsp_status.capabilities,
    flags = {debounce_text_changes = 150},
    on_attach = lsp_attach
})

-- other LSPs
local default_servers = {'bashls', 'dockerls', 'rnix', 'rust_analyzer'}
for _, lsp in ipairs(default_servers) do lspconfig[lsp].setup({}) end

lspconfig.jsonls.setup({
    cmd = {'vscode-json-languageserver', '--stdio'},
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line('$'), 0})
            end
        }
    },
    settings = {json = {schemas = require('schemastore').json.schemas()}}
})

local luadev = require("lua-dev").setup({runtime_path = true})
lspconfig.sumneko_lua.setup(luadev)

if vim.fn.getcwd():find('/google/') == nil then
    lspconfig.gopls.setup({})
    lspconfig.pyright.setup({settings = {python = {pythonPath = 'python3'}}})
end
