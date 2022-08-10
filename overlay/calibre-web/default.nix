{ calibre-web }: calibre-web.overrideAttrs(_: {
  patches = [ ./upload-size.patch ];
})
