{ fortune, kitty, makeWrapper, symlinkJoin, writeTextFile }:

let
  kittySession = writeTextFile {
    name = "session";
    text = "launch fish -C '${fortune}/bin/fortune -sa'";
  };
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "kitty";
  paths       = [ kitty ];
  postBuild   = ''
    wrapProgram "$out/bin/kitty" \
      --add-flags "--config ${./kitty.conf}" \
      --add-flags "--session ${kittySession}"
  '';
}
