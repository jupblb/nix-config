{ fish, makeWrapper, symlinkJoin }:

let
  x = "y";
in symlinkJoin {
  name        = "fish";
  buildInputs = [ makeWrapper ];
  paths       = [ fish ];
  postBuild   = ''
    wrapProgram "$out/bin/fish" \
      --add-flags "-c ${i3Config}" \
      --prefix PATH ':' ${franz}/bin \
      --prefix PATH ':' ${i3status'}/bin \
      --prefix PATH ':' ${idea-ultimate'}/bin \
      --prefix PATH ':' ${imv}/bin \
      --prefix PATH ':' ${mpv}/bin \
      --prefix PATH ':' ${pavucontrol}/bin \
      --prefix PATH ':' ${zoom-us}/bin
  '';
}
