vim.opt.rtp:prepend(os.getenv('NVIM_LAZYDEV'))

require('lazydev').setup({})

vim.lsp.enable('lua_ls')
vim.lsp.enable('vimls')
