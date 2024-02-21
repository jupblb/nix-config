local lspconfig = require('lspconfig')

require('neodev').setup({
    override = function(_, library)
        library.enabled = true
        library.plugins = true
    end,
})

lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file('', true)
            }
        }
    },
})
lspconfig.nil_ls.setup({})
lspconfig.vimls.setup({})
