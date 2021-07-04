local lspconfig = require'lspconfig'
local lspconfigs = require'lspconfig/configs'
local lsp_status = require('lsp-status')

lsp_status.register_progress()

lspconfigs.ciderlsp = {
  default_config = {
    cmd = {'ciderlsp', '--tooltag=nvim-lsp' , '--noforward_sync_responses'};
    filetypes = {'bzl', 'c', 'cpp', 'go', 'java', 'python', 'proto', 'sql', 'textproto'};
    root_dir = lspconfig.util.root_pattern('BUILD');
    settings = {};
  };
}

local function lsp_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

-- using goto_definition_lsp_fallback in nvim-treesitter-refactor
--   buf_set_keymap('n','<C-]>','<cmd>lua vim.lsp.buf.definition()<CR>',opts)
  buf_set_keymap('n','<A-CR>','<cmd>Telescope lsp_code_actions<CR>',opts)
  buf_set_keymap('n','<Leader>ld','<cmd>Telescope lsp_document_diagnostics<CR>',opts)
  buf_set_keymap('n','<Leader>lD','<cmd>Telescope lsp_workspace_diagnostics<CR>',opts)
  buf_set_keymap('n','<Leader>li','<cmd>lua vim.lsp.buf.implementation()<CR>',opts)
  buf_set_keymap('n','<Leader>lr','<cmd>lua vim.lsp.buf.rename()<CR>',opts)
  buf_set_keymap('n','<Leader>ls','<cmd>Telescope lsp_document_symbols<CR>',opts)
  buf_set_keymap('n','<Leader>lS','<cmd>Telescope lsp_workspace_symbols<CR>',opts)
  buf_set_keymap('n','<Leader>lt','<cmd>lua vim.lsp.buf.type_definition()<CR>',opts)
  buf_set_keymap('n','K','<cmd>lua vim.lsp.buf.hover()<CR>',opts)
  buf_set_keymap('n','gr','<cmd>Telescope lsp_references<CR>',opts)
  buf_set_keymap('n','gs','<cmd>lua vim.lsp.buf.signature_help()<CR>',opts)
  buf_set_keymap('n', '[l', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']l', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<A-l>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    buf_set_keymap("n", "<Leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<A-l>", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    buf_set_keymap("v", "<Leader>lf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end

  lsp_status.on_attach(client)
end

local servers = { "bashls", "gopls", "rnix", "vimls" }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = lsp_status.capabilities,
    flags = { debounce_text_changes = 150 },
    on_attach = lsp_attach
  }
end

lspconfig.metals.setup{
  on_attach = lsp_attach;
  root_dir = lspconfig.util.root_pattern("build.sbt", "build.sc", "build.gradle", "pom.xml", ".git")
}

if vim.fn.executable('ciderlsp') == 1 and vim.fn.getcwd():find('/google/') then
  lspconfig.ciderlsp.setup {
    flags = { debounce_text_changes = 150 },
    on_attach = lsp_attach
  }
end
if vim.fn.executable('pyls') == 1 then
  lspconfig.pyls.setup {
    capabilities = lsp_status.capabilities,
    flags = { debounce_text_changes = 150 },
    on_attach = lsp_attach
  }
end
