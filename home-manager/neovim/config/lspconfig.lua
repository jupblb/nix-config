local lspconfig = require('lspconfig')

-- Incremental rename
require("inc_rename").setup({
    preview_empty_name = true,
    show_message = false,
})

vim.keymap.set("n", "<leader>lr", function()
    return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

-- Disable virtual text for errors
vim.diagnostic.config({ virtual_text = false })

-- Replace default signs
local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Add border to the floating windows
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts = opts or {}
    opts.border = opts.border or {
        { '╭', 'FloatBorder' }, { '─', 'FloatBorder' }, { '╮', 'FloatBorder' },
        { '│', 'FloatBorder' }, { '╯', 'FloatBorder' }, { '─', 'FloatBorder' },
        { '╰', 'FloatBorder' }, { '│', 'FloatBorder' }
    }
    return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Setup
_G.lsp_attach = function(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end
        })
    end

    vim.api.nvim_create_autocmd("CursorHold", {
        buffer = bufnr,
        callback = function()
            local opts = {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                border = 'rounded',
                source = 'always',
                prefix = ' ',
                scope = 'cursor',
            }
            vim.diagnostic.open_float(nil, opts)
        end
    })

    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr()')
end

local default_config = {
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = lsp_attach
}
lspconfig.util.default_config = vim.tbl_extend(
    'force', lspconfig.util.default_config, default_config)

if vim.fn.getcwd():find('/google/src/') ~= nil then
    return
end

-- neodev.nvim
require('neodev').setup({
    override = function(root_dir, library)
        if string.find(root_dir, 'nix%-config') or
            string.find(root_dir, 'nvim/site/plugin') then
            library.enabled = true
            library.plugins = true
        end
    end,
})

-- other LSPs
local default_servers = {
    'bashls', 'clangd', 'cssls', 'dockerls', 'eslint', 'graphql', 'hls', 'html',
    'jdtls', 'jsonls', 'lemminx', 'lua_ls', 'marksman', 'nil_ls', 'prismals',
    'pyright', 'rust_analyzer', 'tailwindcss', 'tsserver', 'vimls', 'yamlls',
}
for _, lsp in ipairs(default_servers) do lspconfig[lsp].setup({}) end

-- https://github.com/astral-sh/ruff-lsp?tab=readme-ov-file#example-neovim
lspconfig.ruff_lsp.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
        _G.lsp_attach(client, bufnr)
    end,
})

lspconfig.lua_ls.setup({
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or
            vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return true
        end

        client.config.settings =
            vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                    runtime = { version = 'LuaJIT' },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file("", true)
                    }
                }
            })
        client.notify("workspace/didChangeConfiguration", {
            settings = client.config.settings
        })

        return true
    end
})

lspconfig.metals.setup({ single_file_support = true })
