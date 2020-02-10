{ makeWrapper, sbt, symlinkJoin, xdg-user-dirs }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "sbt";
  paths       = [ sbt ];
  postBuild   = ''
    wrapProgram "$out/bin/sbt" \
    --add-flags "--color=always" \
    --add-flags "--ivy $(${xdg-user-dirs}/bin/xdg-user-dir)/.local/share/ivy2" \
    --add-flags "--mem 8192" \
    --add-flags "--sbt-dir $(${xdg-user-dirs}/bin/xdg-user-dir)/.local/share/sbt"
  '';
}
