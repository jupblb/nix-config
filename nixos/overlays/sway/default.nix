{
  bemenu, firefox-wayland, grim, i3status', imv,
  lib, makeWrapper, mako, mpv, pavucontrol,
  qutebrowser, redshift-wayland', slurp, symlinkJoin, sway,
  withScaling ? false, writeTextFile, xdg-user-dirs, zoom-us
}:

let
  sway-config = writeTextFile {
    name = "config";
    text = ''
      exec --no-startup-id ${mako}/bin/mako -c ${./mako-config}
      exec --no-startup-id ${redshift-wayland'}/bin/redshift -m wayland -l 51.12:17.05
      output * background ${builtins.toString(./wallpaper.png)} fill
      ${lib.optionalString withScaling "output * scale 2"}
      ${lib.optionalString withScaling "seat * xcursor_theme Paper 18"}
      set $browser ${qutebrowser}/bin/qutebrowser
      set $menu ${bemenu}/bin/bemenu-run \
        --fn 'PragmataPro 12' -p "" --fb '$bg' --ff '$fg' --hb '$green' --hf '$fg' --nb '$bg' --nf '$fg' \
        --sf '$bg' --sb '$fg' --tf '$fg' --tb '$bg' | xargs swaymsg exec --
      set $print ${grim}/bin/grim $(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(date +'%s_grim.png')
      ${builtins.readFile(../common-wm-config)}
      ${builtins.readFile(./sway-config)}
      bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" $(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)/screenshots/$(date +'%F_%R:%S_grim.png')
    '';
  };
  sway' = sway.override {
#   extraSessionCommands = builtins.readFile(./sway.sh);
#   withGtkWrapper       = true;
  };
in symlinkJoin {
  name        = "sway";
  buildInputs = [ makeWrapper ];
  paths       = [ sway' ];
  postBuild   = ''
    wrapProgram "$out/bin/sway" \
      --add-flags "-c ${sway-config}" \
      --prefix PATH ':' ${firefox-wayland}/bin \
      --prefix PATH ':' ${i3status'}/bin \
      --prefix PATH ':' ${imv}/bin \
      --prefix PATH ':' ${mpv}/bin \
      --prefix PATH ':' ${pavucontrol}/bin \
      --prefix PATH ':' ${zoom-us}/bin \
      --set-default _JAVA_AWT_WM_NONREPARENTING 1 \
      --set-default ECORE_EVAS_ENGINE "wayland_egl" \
      --set-default ELM_ENGINE "wayland_egl" \
      --set-default KITTY_ENABLE_WAYALAND 1 \
      --set-default QT_QPA_PLATFORM wayland \
      --set-default QT_WAYLAND_DISABLE_WINDOWDECORATION 1 \
      --set-default QT_WAYLAND_FORCE_DPI physical \
      --set-default SDL_VIDEODRIVER wayland
  '';
#     --prefix PATH ':' ${wob}/bin \
}
