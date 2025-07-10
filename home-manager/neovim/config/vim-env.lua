-- https://stackoverflow.com/a/57598640
local metaTable
do
  local path = os.getenv('NVIM_ENV_JSON') or
      string.format('/tmp/nvim-%s%s.json',
        os.getenv('USER') or 'unknown',
        os.getenv('KITTY_WINDOW_ID') or '')
  local protectedTable = {}
  metaTable = {
    __index = function(_, k)
      return protectedTable[k]
    end,
    __newindex = function(_, k, v)
      protectedTable[k] = v
      vim.fn.writefile({ vim.fn.json_encode(protectedTable) }, path)
    end
  }
end

local info = setmetatable({}, metaTable)
info['FILES'] = {}
info['FILES_W'] = {}

local vimEnvAuGroup = vim.api.nvim_create_augroup('vim-z', {})
vim.api.nvim_create_autocmd('BufEnter', {
  group = vimEnvAuGroup,
  callback = function(args)
    info['FILE'] = args.file
    if args.file ~= '' and
        not vim.tbl_contains(info['FILES'], args.file) then
      info['FILES'] =
          vim.list_extend(info['FILES'], { args.file })
    end
  end,
})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = vimEnvAuGroup,
  callback = function(args)
    if args.file ~= '' and
        not vim.tbl_contains(info['FILES_W'], args.file) then
      info['FILES_W'] =
          vim.list_extend(info['FILES_W'], { args.file })
    end
  end,
})
