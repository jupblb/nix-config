{ lf, lib }:

lf.overrideAttrs(old: {
  patches = (lib.optional (old ? patches) old.patches) ++ [ ./user.patch ];
})
