require('diffview').setup({enhanced_diff_hl = true})

require('neogit').setup({
    signs = {section = {' ', ' '}, item = {' ', ' '}},
    integrations = {diffview = true}
})
