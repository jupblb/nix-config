{ nvim-lsputils, popfix }:

nvim-lsputils.overrideAttrs(_: {
  dependencies = [ popfix ];
})

