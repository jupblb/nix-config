{ glow, makeWrapper, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "glow";
  paths       = [ glow ];
  postBuild   = ''
    wrapProgram "$out/bin/glow" \
    --add-flags "-s light" \
  '';
}
