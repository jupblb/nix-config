{ ammonite, makeWrapper, openjdk11, symlinkJoin }:

let
  ammonite' = ammonite.override { jre = openjdk11; };
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "ammonite";
  paths       = [ ammonite' ];
  postBuild   = ''
    wrapProgram "$out/bin/amm" \
    --add-flags "--home ~/.local/share/ammonite" \
    --add-flags "--predef ${./predef.scala}" \
    --add-flags "--no-home-predef"
  '';
}
