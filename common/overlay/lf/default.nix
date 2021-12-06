{ lf, makeWrapper, symlinkJoin }:

symlinkJoin {
  inherit (lf) name;
  buildInputs = [ makeWrapper ];
  paths       = [ lf ];
  postBuild   = ''
    wrapProgram $out/bin/lf \
      --set-default LF_ICONS "${builtins.readFile ./lf-icons.cfg}"
  '';
}
