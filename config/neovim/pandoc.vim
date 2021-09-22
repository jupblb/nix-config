let g:pandoc#syntax#conceal#cchar_overrides = {"codelang" : "", "strike": " "}
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#style#underline_special = 0

autocmd BufNewFile,BufRead,BufFilePost *.pmd setlocal filetype=pandoc
autocmd Filetype pandoc
    \ hi! link Conceal Normal | hi! link pandocStrikeout htmlStrike
autocmd VimEnter *
    \ let g:pandoc#syntax#codeblocks#embeds#langs = g:markdown_fenced_languages
