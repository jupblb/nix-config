{
  fetchFromGitHub, fetchpatch, grim, i3status', lib, mako, makeWrapper,
  redshift-wlr, slurp, symlinkJoin, sway, sway-unwrapped, swayidle, swaylock,
  wayvnc, wdisplays, wl-clipboard, wlroots', wob, writeTextFile, xdg-user-dirs,
  xsettingsd, xwayland'
}:

let
  binPaths  = lib.makeBinPath [
    i3status' wdisplays wl-clipboard xsettingsd xwayland'
  ];
  config    = {
    common   =
      let
        picture-dir = "$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)";
      in ''
        ${builtins.readFile ./sway-config}
        output * background ${builtins.toString ./wallpaper.png} fill
        bindsym Print exec ${grim}/bin/grim \
          ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')
        bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" \
          ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')
        include ~/.config/sway/config
      '';
    headless = writeTextFile {
      name = "sway-config-headless";
      text = ''
        ${config.common}
        exec ${wayvnc}/bin/wayvnc --keyboard=pl
        seat seat0 keyboard_grouping none
      '';
    };
    regular  = writeTextFile {
      name = "sway-config";
      text = ''
        ${config.common}
        exec --no-startup-id ${redshift-wlr}/bin/redshift \
          -m wayland -l 51.12:17.05
        exec --no-startup-id ${mako}/bin/mako -c ${./mako-config}
        exec --no-startup-id mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob \
          | ${wob}/bin/wob
        exec ${swayidle}/bin/swayidle -w \
          timeout 300 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
          timeout 360 '${swaylock}/bin/swaylock'
        bindsym $mod+BackSpace exec ${swaylock}/bin/swaylock
      '';
    };
  };
  sway'     =
    let
      sway-unwrapped'  = sway-unwrapped.override { wlroots = wlroots'; };
      sway-unwrapped'' = sway-unwrapped'.overrideAttrs(old: rec {
        patches = old.patches ++ [(fetchpatch {
          url    = "https://github.com/swaywm/sway/pull/5090.patch";
          sha256 = "131g9j02gbx0dsln6zp5fbr6vmvar11q2hbpq6dvfjlhj2ckxa4v";
        })];
        src     = fetchFromGitHub {
          owner  = "swaywm";
          repo   = "sway";
          rev    = "52bd6aecf24af2aefc202d73aeef205cd62fa8b8";
          sha256 = "1vly3qz6mzpvwfxh5la73qz2cy800c1y9ly9dlqcz06pzw69cram";
        };
      });
    in sway.override {
      extraSessionCommands = builtins.readFile ./sway.sh;
      sway-unwrapped       = sway-unwrapped'';
      withGtkWrapper       = true;
    };
in symlinkJoin {
  name        = "sway";
  buildInputs = [ makeWrapper ];
  paths       = [ sway' ];
  postBuild   = with lib; ''
    mv $out/bin/sway $out/bin/sway-clean

    makeWrapper "$out/bin/sway-clean" $out/bin/sway \
      --add-flags "-c ${config.regular}" \
      --prefix PATH : ${binPaths}

    makeWrapper "$out/bin/sway-clean" $out/bin/sway-headless \
      --add-flags "-c ${config.headless}" \
      --prefix PATH : ${binPaths} \
      --set WLR_BACKENDS "headless" \
      --set WLR_LIBINPUT_NO_DEVICES 1
  '';
}
