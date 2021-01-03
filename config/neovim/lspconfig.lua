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

local function lsp_attach(_)
  vim.api.nvim_buf_set_keymap(0,'n','<C-]>','<cmd>lua vim.lsp.buf.definition()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>la','<cmd>lua vim.lsp.buf.code_action()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>ld','<cmd>lua vim.lsp.buf.document_symbol()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>lf','<cmd>lua vim.lsp.buf.formatting()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>lr','<cmd>lua vim.lsp.buf.rename()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','<Leader>lw','<cmd>lua vim.lsp.buf.workspace_symbol()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','K','<cmd>lua vim.lsp.buf.hover()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gi','<cmd>lua vim.lsp.buf.implementation()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gr','<cmd>lua vim.lsp.buf.references()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>',{noremap = true})
  vim.api.nvim_buf_set_keymap(0,'n','gt','<cmd>lua vim.lsp.buf.type_definition()<CR>',{noremap = true})

  vim.api.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end

lspconfig.bashls.setup{on_attach=lsp_attach}
lspconfig.cssls.setup{on_attach=lsp_attach}
lspconfig.html.setup{on_attach=lsp_attach}
lspconfig.jsonls.setup{on_attach=lsp_attach}
lspconfig.metals.setup{on_attach=lsp_attach}
lspconfig.tsserver.setup{on_attach=lsp_attach}
lspconfig.rnix.setup{on_attach=lsp_attach}
lspconfig.vimls.setup{on_attach=lsp_attach}
lspconfig.yamlls.setup{on_attach=lsp_attach}

if os.execute('which ciderlsp') == 0 then
  lspconfig.ciderlsp.setup{on_attach=lsp_attach}
end
if os.execute('which haskell-language-server') == 0 then
  lspconfig.hls.setup{on_attach=lsp_attach}
end
if os.execute('which pyls') == 0 then
  lspconfig.pyls.setup{on_attach=lsp_attach}
end
