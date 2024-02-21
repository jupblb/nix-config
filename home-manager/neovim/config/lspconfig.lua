local lspconfig = require('lspconfig')
local cmp = require('cmp')

-- Incremental rename
require('inc_rename').setup({
    preview_empty_name = true,
    show_message = false,
})

vim.keymap.set('n', '<leader>lr', function()
    return ':IncRename ' .. vim.fn.expand('<cword>')
end, { expr = true })

-- Disable virtual text for errors
vim.diagnostic.config({ virtual_text = false })

-- Replace default signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
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
local lspAttachAuGroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp_attach = function(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer   = bufnr,
            callback = vim.lsp.buf.document_highlight,
            group    = lspAttachAuGroup,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer   = bufnr,
            callback = vim.lsp.buf.clear_references,
            group    = lspAttachAuGroup,
        })
    end

    vim.api.nvim_create_autocmd('CursorHold', {
        buffer   = bufnr,
        callback = function()
            vim.diagnostic.open_float(nil, {
                focusable    = false,
                close_events = {
                    'BufLeave', 'CursorMoved', 'InsertEnter', 'FocusLost'
                },
                border       = 'rounded',
                source       = 'always',
                prefix       = ' ',
                scope        = 'cursor',
            })
        end,
        group    = lspAttachAuGroup,
    })

    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
    end

    vim.api.nvim_buf_set_option(bufnr, 'tagfunc', 'v:lua.vim.lsp.tagfunc')

    if vim.fn.getcwd():find('/google/src/') ~= nil then
        return
    end

    cmp.setup.buffer({
        sources = cmp.config.sources({
            { name = 'copilot' }, { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' }, { name = 'async_path' },
            { name = 'latex_symbols' }, { name = 'fish' },
        }),
    })
end

local default_config = {
    capabilities = require('cmp_nvim_lsp').default_capabilities({
        snippetSupport = false,
    }),
    on_attach    = lsp_attach
}
lspconfig.util.default_config = vim.tbl_extend(
    'force', lspconfig.util.default_config, default_config)

-- other LSPs
local default_servers = { 'bashls', 'jsonls', 'marksman', 'yamlls', }
for _, lsp in ipairs(default_servers) do lspconfig[lsp].setup({}) end
