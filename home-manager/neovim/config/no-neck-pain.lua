local no_neck_pain = require("no-neck-pain")

no_neck_pain.setup({
    autocmds = {
        enableOnVimEnter             = true,
        enableOnTabEnter             = true,
        skipEnteringNoNeckPainBuffer = true,
    },
    buffers = {
        colors = { background = "#fbf1c7" },
    },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern  = { "java", "kotlin", "sql" },
    callback = function(_)
        if _G.NoNeckPain.state == nil or not _G.NoNeckPain.state.enabled then
            return
        end
        no_neck_pain.resize(105)
    end,
    group    = "NoNeckPainAutocmd",
})
