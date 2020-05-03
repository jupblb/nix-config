set background=light
set clipboard+=unnamedplus
set ignorecase
set mouse=a
set nowrap
set number
set shell=bash
set smartcase
set termguicolors

" Remap leader key to space
nnoremap <Space> <Nop>
let mapleader="\<Space>"

" Use spaces for indentation
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
autocmd FileType make noexpandtab

" Remap split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Other mappings
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>n :set invnumber<CR>:SignifyToggle<CR>

" Airline
set noshowmode
if ( $TERM != 'xterm-kitty' )
    let g:airline_symbols_ascii = 1
    let g:webdevicons_enable_airline_statusline = 0
else
    let g:airline_powerline_fonts = 1
    let g:airline_symbols_ascii = 0
endif

" coc.nvim
set cmdheight=2
set hidden
set shortmess+=c
set signcolumn=yes
set updatetime=200

inoremap <expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <c-space> coc#refresh()
inoremap <expr> <CR> complete_info()["selected"] != "-1" ?
  \ "\<C-y>" : "\<C-g>u\<CR>"

nmap     <Leader>ld <Plug>(coc-definition)
nmap     <Leader>lt <Plug>(coc-type-definition)
nmap     <Leader>li <Plug>(coc-implementation)
nmap     <Leader>lu <Plug>(coc-references)
nmap     <Leader>lr <Plug>(coc-rename)
nmap     <Leader>lf :call CocAction('format')<CR>
nnoremap <Leader>lh :call <SID>show_documentation()<CR>

autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

autocmd VimEnter * highlight clear Normal

" Fzf
autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

function! Fzf(command)
  let l:fzf_files_options = 
    \ '--preview "bat --color always --style numbers {2..} | head -'.&lines.'"'
  function! s:edit_devicon_prepended_file(item)
    let l:file_path = a:item[4:-1]
    execute 'silent e' l:file_path
  endfunction
  call fzf#run({
    \ 'source':  a:command . ' | devicon-lookup',
    \ 'sink':    function('s:edit_devicon_prepended_file'),
    \ 'options': '-m ' . l:fzf_files_options,
    \ 'down':    '60%' })
endfunction

nnoremap ;          :Commands<CR>
nnoremap <Leader>/  :BLines<CR>
nnoremap <Leader>b  :Buffers<CR>
if ( $TERM == 'xterm-kitty' )
    nnoremap <Leader>f  :call Fzf("fd -HL --exclude '.git' --type f")<CR>
    nnoremap <Leader>gf :call
      \ Fzf("git ls-files $(git rev-parse --show-toplevel) \| uniq")<CR>
else
    nnoremap <Leader>f  :Files<CR>
    nnoremap <Leader>gf :GFiles<CR>
endif
nnoremap <Leader>h  :History<CR>

" EasyMotion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
nmap <Leader><Leader> <Plug>(easymotion-overwin-f)

" Grepper
let g:grepper = {}
let g:grepper.highlight = 1
let g:grepper.searchreg = 1
let g:grepper.stop = 25
let g:grepper.tools = ['rg', 'git', 'grep']
nnoremap <Leader>r :Grepper<CR>

" Goyo
let g:goyo_width = 200
nmap <Leader>` :Goyo<CR>:hi clear Normal<CR>

" PreviewMarkdown
let g:preview_markdown_auto_update = 1
let g:preview_markdown_parser = 'glow'
let g:preview_markdown_vertical = 1

" Startify
if ( $TERM == 'xterm-kitty' )
    function! StartifyEntryFormat()
        return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction
endif

" Opt plugins auto load
autocmd FileType markdown :packadd preview-markdown

" Colorscheme
if ( $TERM == 'linux' )
    colorscheme pablo
else
    let g:airline_theme = 'gruvbox'
    let g:gruvbox_contrast_light = 'hard'
    let g:gruvbox_italic = 1
    colorscheme gruvbox
endif

