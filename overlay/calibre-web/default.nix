{ calibre-web }: calibre-web.overrideAttrs(old: {
  patches = old.patches ++ [ ./upload-size.patch ];
})
