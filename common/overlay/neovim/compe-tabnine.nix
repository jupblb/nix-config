{ compe-tabnine, tabnine }:

compe-tabnine.overrideAttrs(old: {
  postFixup = old.postFixup + ''
    ln -s ${tabnine}/bin/TabNine-deep-* $target/binaries/
  '';
})
