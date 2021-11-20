_G.metals_config = require("metals").bare_config()

_G.metals_config.init_options.statusBarProvider = "on"

_G.metals_config.on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lC',
                                '<Cmd>Telescope metals commands<CR>', {})
end

_G.metals_config.settings = {
    ammoniteJvmProperties = {"-Xms100M", "-Xmx1G", "-Xss4M"},
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true
}
