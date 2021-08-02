{ htop }:

htop.overrideAttrs(_: { patches = [ ./vim.diff ]; })
