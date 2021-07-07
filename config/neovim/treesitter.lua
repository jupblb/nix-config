require('nvim-treesitter.configs').setup {
  ensure_installed = "maintained",
  ignore_install = { "gdscript", "ocamllex" },
  indent = { enable = true },
  highlight = { enable = true, disable = { "yaml" } },
  refactor = {
    highlight_definitions = { enable = true },
    navigation = { enable = true, keymaps = { goto_definition = '<C-]>' } },
    smart_rename = { enable = true, smart_rename = "<Leader>lr" }
  }
}
