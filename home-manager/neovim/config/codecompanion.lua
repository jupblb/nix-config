if os.getenv('GEMINI_API_KEY') == nil then
    return
end

require("codecompanion").setup({
    adapters   = {
        opts = {
            show_defaults = false,
        },

        gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
                schema = {
                    model = { default = "gemini-2.5-pro-preview-05-06" },
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
