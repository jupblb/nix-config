let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_math = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_strikethrough = 1

autocmd FileType markdown nmap <buffer> gd <Plug>Markdown_EditUrlUnderCursor
