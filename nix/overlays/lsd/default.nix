{ lsd }:

lsd.overrideAttrs(old: rec {
  patches = [ ./gruvbox.patch ];
})
