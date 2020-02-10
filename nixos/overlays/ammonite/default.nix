{ ammonite, makeWrapper, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "ammonite";
  paths       = [ ammonite ];
  postBuild   = ''
    wrapProgram "$out/bin/amm" \
    --add-flags "--home ~/.local/share/ammonite" \
    --add-flags "--predef ${./predef.sc}" \
    --add-flags "--no-home-predef"
  '';
}
