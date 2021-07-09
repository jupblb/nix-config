luatab = require('luatab').tabline
vim.cmd("set tabline=%!luaeval('luatab()')")
