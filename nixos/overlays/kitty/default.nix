{ kitty, makeWrapper, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "kitty";
  paths       = [ kitty ];
  postBuild   = ''
    wrapProgram "$out/bin/kitty" --add-flags "--config ${./kitty.conf}"
  '';
}
