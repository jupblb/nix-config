local completion = require'completion'
local lspconfig = require'lspconfig'
local lspconfigs = require'lspconfig/configs'

lspconfigs.ciderlsp = {
  default_config = {
    cmd = {'ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    filetypes = {'bzl', 'c', 'cpp', 'go', 'java', 'python', 'proto', 'sql', 'textproto'};
    root_dir = lspconfig.util.root_pattern('BUILD');
    settings = {};
  };
}

vim.api.nvim_set_var('completion_enable_auto_popup', 0)
vim.api.nvim_set_keymap('i','<C-Space>',[[<cmd>lua require'completion'.triggerCompletion()<CR>]],{noremap = true})

local function lsp_attach(_)
  vim.api.nvim_buf_set_keymap(0,'n','<C-]>',':Definitions<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>la',':CodeActions<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>ld',':DocumentSymbols!<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>lf','<cmd>lua vim.lsp.buf.formatting()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>lr','<cmd>lua vim.lsp.buf.rename()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>lw',':WorkspaceSymbols!<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','K','<cmd>lua vim.lsp.buf.hover()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gi',':Implementations!<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gr',':References!<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gt',':TypeDefinitions<CR>',{noremap = true})

  completion.on_attach()
end

lspconfig.bashls.setup{on_attach = lsp_attach}
lspconfig.cssls.setup{on_attach = lsp_attach}
lspconfig.gopls.setup{on_attach = lsp_attach}
lspconfig.html.setup{on_attach = lsp_attach}
lspconfig.jsonls.setup{on_attach = lsp_attach}
lspconfig.metals.setup{on_attach = lsp_attach}
lspconfig.tsserver.setup{on_attach = lsp_attach}
lspconfig.rnix.setup{on_attach = lsp_attach}
lspconfig.vimls.setup{on_attach = lsp_attach}
lspconfig.yamlls.setup{on_attach = lsp_attach}

if vim.fn.executable('ciderlsp') == 1 then
  lspconfig.ciderlsp.setup{on_attach = lsp_attach}
end
if vim.fn.executable('haskell-language-server') == 1 then
  lspconfig.hls.setup{on_attach = lsp_attach}
end
if vim.fn.executable('pyls') == 1 then
  lspconfig.pyls.setup{on_attach = lsp_attach}
end
