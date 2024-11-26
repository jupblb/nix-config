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

-- Format markdown with :MarkdownFormat
local commonmark = 'commonmark+footnotes+pipe_tables+task_lists+tex_math_dollars+yaml_metadata_block'

_G.markdown_formatters = {
    ['Pandoc (with reference-links)'] = {
        'pandoc', '--columns=80', '--reference-links', '-s', '-f', 'markdown',
        '-t', commonmark, '-'
    },
    ['Pandoc (without reference-links)'] = {
        'pandoc', '--columns=80', '-s', '-f', 'markdown', '-t', commonmark, '-'
    },
    ['Pandoc (gfm)'] = {
        'pandoc', '--columns=80', '-s', '-f', 'gfm', '-t', 'gfm', '-'
    },
}

local markdown_format = function()
    local available_formatters = {}
    for formatter, _ in pairs(_G.markdown_formatters) do
        table.insert(available_formatters, formatter)
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local format = function(formatter)
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
        local cmd = table.concat(_G.markdown_formatters[formatter], ' ')
        local output = vim.fn.systemlist(cmd, lines)
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, output)
    end

    vim.ui.select(
        available_formatters, { prompt = "Select formatter:" }, format)
end

vim.api.nvim_create_user_command('MarkdownFormat', markdown_format, {})
