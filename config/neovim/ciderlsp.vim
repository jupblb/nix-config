packadd nvim-lspconfig

lua << EOF
local lspconfig = require 'lspconfig'
require'lspconfig/configs'.ciderlsp = {
  default_config = {
    cmd = {'ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    filetypes = {'bzl', 'c', 'cpp', 'go', 'java', 'python', 'proto', 'sql', 'textproto'};
    root_dir = lspconfig.util.root_pattern('BUILD');
    settings = {};
  };
}
local function lsp_attach(_)
  vim.api.nvim_command('setlocal omnifunc=v:lua.vim.lsp.omnifunc')
end
lspconfig.ciderlsp.setup{on_attach=lsp_attach}
EOF

