{ ammonite, symlinkJoin, makeWrapper }:

symlinkJoin {
  name        = "ammonite";
  buildInputs = [ makeWrapper ];
  paths       = [ ammonite ];
  postBuild   = ''
    wrapProgram "$out/bin/amm" \
    --add-flags "--home ~/.local/share/ammonite" \
    --add-flags "--predef ${builtins.toString ./predef.sc}" \
    --add-flags "--no-home-predef"
  '';
}
