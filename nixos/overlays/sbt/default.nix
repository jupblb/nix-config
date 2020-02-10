{ sbt, symlinkJoin, makeWrapper }:

symlinkJoin {
  name        = "sbt";
  buildInputs = [ makeWrapper ];
  paths       = [ sbt ];
  postBuild   = ''
    wrapProgram "$out/bin/sbt" \
    --add-flags "--ivy ~/.local/share/ivy2" \
    --add-flags "--sbt-dir ~/.local/share/sbt"
  '';
}
