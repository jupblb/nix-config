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
    if client.server_capabilities.completionProvider then
        vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
        })
    end
end

vim.lsp.config('*', {
    on_attach = { lsp_attach },
})

-- Completion navigation keymaps
vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })

local markdown_format = function(to)
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)

    local shebang
    if lines[1] and lines[1]:match('^#!') == '#!' then
        shebang = table.remove(lines, 1)
        if lines[1] == '' then
            table.remove(lines, 1)
        end
    end

    local cmd = 'pandoc --columns=80 --reference-links --standalone ' ..
        '--wrap=' .. (vim.g.markdown_format_wrap or 'auto') ..
        ' --from markdown --to ' .. to .. ' -'
    local output = vim.fn.systemlist(cmd, lines)

    if shebang then
        table.insert(output, 1, '')
        table.insert(output, 1, shebang)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, output)
end

vim.api.nvim_create_user_command('MarkdownFormat',
    function() markdown_format('gfm') end, {})
vim.api.nvim_create_user_command('MarkdownFormatPandoc',
    function()
        -- Disabling the other table styles makes pandoc always emit grid
        -- tables, which wrap cell contents to fit --columns; disabling
        -- smart keeps typographic quotes and dashes intact.
        markdown_format('markdown-simple_tables-multiline_tables' ..
            '-pipe_tables-smart')
    end, {})
