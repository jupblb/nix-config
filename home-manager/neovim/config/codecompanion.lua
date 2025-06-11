if os.getenv('GEMINI_API_KEY') == nil then
    return
end

local codecompanion = require("codecompanion")

codecompanion.setup({
    adapters   = {
        opts = {
            show_defaults = false,
        },

        gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
                schema = {
                    model = { default = "gemini-2.5-pro-preview-06-05" },
                },
            })
        end,
    },
    strategies = {
        chat   = { adapter = "gemini" },
        cmd    = { adapter = "gemini" },
        inline = { adapter = "gemini" },
    },
})

vim.keymap.set('n', '<Leader>c', codecompanion.chat, { expr = true })
vim.keymap.set('n', '<Leader>C', codecompanion.actions, { expr = true })
