nnoremap <Leader>c :Calendar<CR>

autocmd FileType calendar nmap <silent> <buffer> <CR> :<C-u>call
  \ vimwiki#diary#calendar_action(b:calendar.day().get_day(),
  \ b:calendar.day().get_month(), b:calendar.day().get_year(),
  \ b:calendar.day().week(), "V")<CR>

if filereadable(expand("~/.config/nvim/google.vim"))
  source ~/.config/nvim/google.vim
endif

