local no_neck_pain = require("no-neck-pain")

-- sign-column (2) + number-column (4) + color-column (1) + right edge (1)
local add_width = 8
local width = 80 + add_width

-- Consistent sign column width
vim.o.signcolumn = "yes"

no_neck_pain.setup({
    width = width,
    autocmds = {
        enableOnVimEnter             = true,
        enableOnTabEnter             = true,
        skipEnteringNoNeckPainBuffer = true,
    },
    buffers = {
        colors = { background = "#fbf1c7" },
    },
})

-- Resize for filetypes with longer variable names
_G.resize_for_longer_filetype = false

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern  = { "java", "kotlin", "sql" },
    callback = function(_)
        if _G.NoNeckPain.state == nil or not _G.NoNeckPain.state.enabled then
            return
        end

        if _G.resize_for_longer_filetype then
            return
        end
        _G.resize_for_longer_filetype = true

        width = width + 20
        no_neck_pain.resize(width)
    end,
    group    = "NoNeckPainAutocmd",
})

-- Resize if a file with >1k lines is opened
_G.thousand_lines = false

vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern  = "*",
    callback = function()
        if _G.NoNeckPain.state == nil or not _G.NoNeckPain.state.enabled then
            return
        end

        if _G.thousand_lines then
            return
        end

        if vim.api.nvim_buf_line_count(0) >= 1000 then
            _G.thousand_lines = true
            width = width + 1
            no_neck_pain.resize(width)
        end
    end,
    group    = "NoNeckPainAutocmd",
})
