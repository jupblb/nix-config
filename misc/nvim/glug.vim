source ~/.config/nvim/glug.vim

Glug fzf-query
Glug google-csimporter
Glug google-filetypes
Glug relatedfiles

command! -nargs=1 Cs FzfCs <args>

nnoremap <Leader>ji :CsImporter<CR>
nnoremap <Leader>js :CsImporterSort<CR>
nnoremap <Leader>t  :RelatedFilesWindow<CR>

