if vim.fn.getcwd():find('/google/src/') ~= nil then
    return
end

require("codecompanion").setup({
    adapters   = {
        gemini = function()
            return require("codecompanion.adapters").extend("gemini", {
                schema = {
                    model = { default = "gemini-2.0-flash-exp" },
                },
            })
        end,
    },
    strategies = {
        chat   = {
            adapter = "gemini",
        },
        inline = {
            adapter = "gemini",
        },
    },
})
