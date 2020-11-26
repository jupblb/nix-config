packadd nvim-lspconfig

lua << EOF
local nvim_lsp = require 'lspconfig'
local configs  = require 'lspconfig/configs'
configs.ciderlsp = {
  default_config = {
    cmd = {'ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    filetypes = {'bzl', 'c', 'cpp', 'go', 'java', 'python', 'proto', 'sql', 'textproto'};
    root_dir = nvim_lsp.util.root_pattern('BUILD');
    settings = {};
  };
}

local function set_lsp_omnifunc(_)
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

nvim_lsp.ciderlsp.setup{on_attach=set_lsp_omnifunc}
EOF

