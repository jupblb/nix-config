require('gitsigns').setup({
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function nmap(l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set('n', l, r, opts)
        end

        nmap('<leader>hb', function() gs.blame_line { full = true } end)
        nmap('<leader>hD', function() gs.diffthis('~') end)
        nmap('<leader>hp', gs.preview_hunk)
        nmap('<leader>hr', ':Gitsigns reset_hunk<CR>')
        nmap('<leader>hR', gs.reset_buffer)
        nmap('<leader>hs', ':Gitsigns stage_hunk<CR>')
        nmap('<leader>hS', gs.stage_buffer)
        nmap('<leader>hu', gs.undo_stage_hunk)
    end,
    signcolumn = false,
})
