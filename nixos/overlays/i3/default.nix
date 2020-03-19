{
  bemenu, dunst, firefox, ferdi', gnome-screenshot,
  i3-gaps, i3status', idea-ultimate', imv, lib,
  makeWrapper, mpv, pavucontrol, qutebrowser, redshift,
  symlinkJoin, writeTextFile, zoom-us
}:

let
  i3Config = writeTextFile {
    name = "config";
    text = ''
      exec --no-startup-id ${dunst}/bin/dunst -conf ${./dunstrc}
      exec --no-startup-id ${redshift}/bin/redshift -l 51.12:17.05
      set $browser env QT_SCALE_FACTOR=2 ${qutebrowser}/bin/qutebrowser \
        --basedir ~/.local/share/qutebrowserx
      set $menu ${bemenu}/bin/bemenu-run --fn 'PragmataPro 26' -p "" \
        --fb '#282828' --ff '#f9f5d7' --hb '#98971a' --hf '#f9f5d7' \
        --nb '#282828' --nf '#f9f5d7' --sf '#282828' --sb '#f9f5d7' \
        --tf '#f9f5d7' --tb '#282828' | xargs swaymsg exec --
      set $print ${gnome-screenshot}/bin/gnome-screenshot -i --display=:0
      ${builtins.readFile(../common-wm-config)}
      ${builtins.readFile(./i3-config)}
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
        firefox ferdi' i3status' idea-ultimate' imv mpv pavucontrol zoom-us
      ]}
  '';
}
