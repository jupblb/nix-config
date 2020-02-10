{ makeWrapper, sbt, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "sbt";
  paths       = [ sbt ];
  postBuild   = ''
    wrapProgram "$out/bin/sbt" \
    --add-flags "--ivy ~/.local/share/ivy2" \
    --add-flags "--sbt-dir ~/.local/share/sbt"
  '';
}
