{ lf }:

lf.overrideAttrs(_: { patches = [ ./user.patch ]; })
