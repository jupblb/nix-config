lua vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
lua vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
lua vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
lua vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
lua vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler

