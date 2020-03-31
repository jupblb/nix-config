{
  bemenu, dunst, firefox, ferdi', gnome-screenshot, i3-gaps, i3status',
  idea-ultimate', imv, lib, makeWrapper, mpv, pavucontrol, qutebrowser,
  redshift, symlinkJoin, writeTextFile, zoom-us
}:

let
  i3Config = writeTextFile {
    name = "config";
    text = ''
      exec --no-startup-id ${dunst}/bin/dunst -conf ${./dunstrc}
      ${builtins.readFile(../common-wm-config)}
      ${builtins.readFile(./i3-config)}
    '';
  };

  qutebrowser' = symlinkJoin {
    name = "qutebrowser";
    buildInputs = [ makeWrapper ];
    paths = [ qutebrowser ];
    postBuild = ''
      wrapProgram "$out/bin/qutebrowser" \
        --add-flags "--basedir ~/.local/share/qutebrowserx" \
        --set-default QT_SCALE_FACTOR 2
    '';
  };
in symlinkJoin {
  name        = "i3";
  buildInputs = [ makeWrapper ];
  paths       = [ i3-gaps ];
  postBuild   = ''
    wrapProgram "$out/bin/i3" \
      --add-flags "-c ${i3Config}" \
      --prefix PATH : ${lib.makeBinPath[
        bemenu
        firefox ferdi'
        gnome-screenshot
        i3status' idea-ultimate' imv
        mpv
        pavucontrol
        qutebrowser'
        redshift
        zoom-us
      ]}
  '';
}
