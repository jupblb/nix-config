{ i3-gaps, makeWrapper, symlinkJoin }:

symlinkJoin {
  name        = "i3";
  buildInputs = [ makeWrapper ];
  paths       = [ i3-gaps ];
  postBuild   = ''wrapProgram "$out/bin/i3" --add-flags "-c /etc/i3/config"'';
}
