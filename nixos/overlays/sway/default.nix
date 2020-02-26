{
  bemenu, grim, i3status', imv, lib, 
  makeWrapper, mako, mpv, pavucontrol, qutebrowser,
  redshift', slurp, symlinkJoin, sway, withScaling ? false,
  wob, writeTextFile, xdg-user-dirs, zoom-us
}:

let
  sway-config = writeTextFile {
    name = "config";
    text = ''
      output * background ${../wallpaper.png} fill
      ${lib.optionalString withScaling "output * scale 2"}
      exec --no-startup-id ${mako}/bin/mako -c ${./mako-config}
      exec --no-startup-id ${redshift'}/bin/redshift -m wayland -l 51.12:17.05
      set $browser ${qutebrowser}/bin/qutebrowser
      set $menu ${bemenu}/bin/bemenu-run \
        --fn 'PragmataPro 12' -p "" --fb '$bg' --ff '$fg' --hb '$green' --hf '$fg' --nb '$bg' --nf '$fg' \
        --sf '$bg' --sb '$fg' --tf '$fg' --tb '$bg' | xargs swaymsg exec --
      set $print ${grim}/bin/grim $(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
      ${builtins.readFile(../common-config)}
      ${builtins.readFile(./sway-config)}
      bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" $(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(date +'%F_%R:%S_grim.png')
    '';
  };
  sway' = sway.override {
    extraSessionCommands = builtins.readFile(./sway.sh);
    withGtkWrapper       = true;
  };
in symlinkJoin {
  name        = "sway";
  buildInputs = [ makeWrapper ];
  paths       = [ sway' ];
  postBuild   = ''
    wrapProgram "$out/bin/sway" \
      --add-flags "-c ${sway-config}" \
      --prefix PATH ':' ${i3status'}/bin \
      --prefix PATH ':' ${imv}/bin \
      --prefix PATH ':' ${mpv}/bin \
      --prefix PATH ':' ${pavucontrol}/bin \
      --prefix PATH ':' ${wob}/bin \
      --prefix PATH ':' ${zoom-us}/bin
  '';
}
