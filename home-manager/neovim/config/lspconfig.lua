local lspconfig = require('lspconfig')

-- Disable virtual text for errors
vim.diagnostic.config({ virtual_text = false })

-- Replace default signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add border to the floating windows
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or {
        { '╭', 'FloatBorder' }, { '─', 'FloatBorder' }, { '╮', 'FloatBorder' },
        { '│', 'FloatBorder' }, { '╯', 'FloatBorder' }, { '─', 'FloatBorder' },
        { '╰', 'FloatBorder' }, { '│', 'FloatBorder' }
    }
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Setup
_G.lsp_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
end

local default_config = {
    capabilities = require('cmp_nvim_lsp')
        .update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = lsp_attach
}
lspconfig.util.default_config = vim.tbl_extend(
    'force', lspconfig.util.default_config, default_config)

-- other LSPs
local default_servers = {
    'bashls', 'dockerls', 'hls', 'rnix', 'rust_analyzer', 'vimls'
}
for _, lsp in ipairs(default_servers) do lspconfig[lsp].setup({}) end

lspconfig.jdtls.setup({
    cmd = { 'jdt-language-server', '-data', os.getenv('HOME') .. '/.cache/jdtls' }
})

lspconfig.jsonls.setup({
    cmd = { 'vscode-json-languageserver', '--stdio' },
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting(
                    {}, { 0, 0 }, { vim.fn.line('$'), 0 })
            end
        }
    },
    settings = { json = { schemas = require('schemastore').json.schemas() } }
})

local luadev = require("lua-dev").setup({ runtime_path = true })
lspconfig.sumneko_lua.setup(luadev)

lspconfig.metals.setup({
    root_dir = function(filename)
        local pattern = lspconfig.util.root_pattern(
            'build.sbt', 'build.sc', 'build.gradle', 'pom.xml')
        return pattern(filename) or vim.fn.getcwd()
    end,
    single_file_mode = true,
})

if vim.fn.getcwd():find('/google/src/') == nil then
    lspconfig.gopls.setup({
        settings = { gopls = { gofumpt = true, staticcheck = true } }
    })
    lspconfig.pyright.setup({})
end
