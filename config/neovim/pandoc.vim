let g:pandoc#syntax#conceal#cchar_overrides = {"codelang" : "", "strike": " "}
let g:pandoc#syntax#style#underline_special = 0

autocmd BufNewFile,BufRead,BufFilePost *.markdown,*.md
    \ let b:did_ftplugin=1 | setlocal filetype=pandoc | setlocal conceallevel=1
autocmd Filetype pandoc
    \ hi! link Conceal Normal | hi! link pandocStrikeout htmlStrike
autocmd VimEnter *
    \ let g:pandoc#syntax#codeblocks#embeds#langs = g:markdown_fenced_languages
