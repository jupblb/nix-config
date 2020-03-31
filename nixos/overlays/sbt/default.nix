{ makeWrapper, sbt, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "sbt";
  paths       = [ sbt ];
  postBuild   = ''
    wrapProgram "$out/bin/sbt" \
      --add-flags "--color=always" \
      --add-flags "--mem 8192"
  '';
}
