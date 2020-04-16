{ fortune, kitty, makeWrapper, symlinkJoin, writeTextFile }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "kitty";
  paths       = [ kitty ];
  postBuild   = ''
    wrapProgram "$out/bin/kitty" \
      --add-flags "--config ${./kitty.conf}"
  '';
}
