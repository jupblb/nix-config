require("image").setup({})

require("diagram").setup({
    integrations = {
        require("diagram.integrations.markdown"),
    },
    renderer_options = {
        mermaid = {},
    },
})
