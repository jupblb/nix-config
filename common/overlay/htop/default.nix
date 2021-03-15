{ htop }:

htop.overrideAttrs(_: { patches = [ ./vim.patch ]; })
