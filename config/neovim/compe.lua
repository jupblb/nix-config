require'compe'.setup {
  source = {
    buffer = true;
    emoji = true;
    nvim_lsp = true;
    nvim_lua = true;
    -- nvim_treesitter = true;
    path = true;
    tabnine = { max_num_results = 3; };
  };
}

vim.opt.completeopt = {'menuone', 'noselect'}

local opts = { expr=true, noremap=true, silent=true }
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", opts)
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", opts)
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')", opts)

-- See: https://github.com/hrsh7th/nvim-compe#how-to-use-tab-to-navigate-completion-menu
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", opts)
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", opts)
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", opts)
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", opts)
