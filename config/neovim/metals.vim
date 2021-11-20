set shortmess-=F

augroup lsp
  autocmd!
  autocmd FileType scala,sbt
    \ lua require("metals").initialize_or_attach(metals_config)
augroup end
