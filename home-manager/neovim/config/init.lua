local function paste()
    return { vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('') }
end

vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
        ['+'] = paste,
        ['*'] = paste,
    },
}

-- Toggle diagnostics with <Leader>d
local diagnostics_active = true
local diagnostics_toggle = function()
    if diagnostics_active then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
    diagnostics_active = not diagnostics_active
end

vim.keymap.set('n', '<Leader>d', diagnostics_toggle, {})

vim.diagnostic.config({
    virtual_text = false,
    signs        = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.HINT] = '',
            [vim.diagnostic.severity.INFO] = '',
        },
    },
})

-- https://github.com/nvim-telescope/telescope.nvim/issues/3436#issuecomment-2888940156
vim.keymap.set(
    'n', 'K', function() vim.lsp.buf.hover({ border = "rounded" }) end)

-- LSP Setup
local lspAttachAuGroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp_attach = function(client, bufnr)
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
end

vim.lsp.config('*', {
    on_attach = { lsp_attach },
})

-- Format markdown with :MarkdownFormat
local markdown_format = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
    local cmd = 'pandoc --columns=80 --reference-links -s -f gfm -t gfm -'
    local output = vim.fn.systemlist(cmd, lines)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, output)
end

vim.api.nvim_create_user_command('MarkdownFormat', markdown_format, {})
