let g:mergetool_layout = 'lmr'
let g:mergetool_prefer_revision = 'unmodified'

nmap <expr> <C-,> &diff? '<Plug>(MergetoolDiffExchangeLeft)' : '<C-,>'
nmap <expr> <C-.> &diff? '<Plug>(MergetoolDiffExchangeRight)' : '<C-.>'
