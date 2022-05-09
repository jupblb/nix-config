vim.opt_global.shortmess:remove("F")

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals",
                                                      {clear = true})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"scala", "sbt"},
    callback = function() require("metals").initialize_or_attach({}) end,
    group = nvim_metals_group
})

local metals_config = require("metals").bare_config()
metals_config.init_options.statusBarProvider = "on"
metals_config.on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>lC',
                                '<Cmd>Telescope metals commands<CR>', {})
end
metals_config.settings = {
    ammoniteJvmProperties = {"-Xms100M", "-Xmx1G", "-Xss4M"},
    showImplicitArguments = true,
    showImplicitConversionsAndClasses = true,
    showInferredType = true
}
