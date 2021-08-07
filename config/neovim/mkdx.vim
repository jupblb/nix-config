let g:markdown_fenced_languages = [
    \    'c', 'cpp', 'css', 'java', 'go', 'javascript', 'js=javascript',
    \    'json', 'python', 'sh', 'typescript', 'yaml'
    \  ]
let g:mkdx#settings = {
    \   'enter': { 'shift': 1 },
    \   'highlight': { 'enable': 1 },
    \   'links': { 'conceal': 2, 'external': { 'enable': 1 } },
    \   'map': { 'prefix': '<Leader>l' },
    \   'tab': { 'enable': 1 },
    \   'table': { 'align': { 'default': 'left' } },
    \   'toc': { 'position': 1, 'text': 'Table of contents' }
    \ }
