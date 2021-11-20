local lsp_status = require('lsp-status')

lsp_status.config({
    indicator_errors = ' ',
    indicator_hint = ' ',
    indicator_info = ' ',
    indicator_ok = ' ',
    indicator_warnings = ' ',
    status_symbol = ''
})
lsp_status.register_progress()
