{
  autoreconfHook, bemenu, edid-generator, ferdi', fetchFromGitHub, fetchgit,
  fetchpatch, firefox-wayland, fontutil, grim, i3status', idea-ultimate', imv,
  kitty', lib, makeWrapper, mako, mpv, pavucontrol, qutebrowser,
  redshift-wayland', slurp, symlinkJoin, sway, sway-unwrapped, swayidle,
  swaylock, utilmacros, wayvnc, wdisplays, wl-clipboard, wlroots, wob,
  writeTextFile, xdg-user-dirs, xorgserver, xwayland, zoom-us, stdenv, 

  additionalConfig ? "",
  withExtraPackages ? false,
  withScaling ? false
}:

let
  bin-paths        = lib.makeBinPath[
    bemenu firefox-wayland i3status' kitty' pavucontrol qutebrowser wl-clipboard
  ];
  bin-paths-extra  = lib.makeBinPath[
    ferdi' idea-ultimate' imv mpv xwayland' wdisplays zoom-us
  ];
  picture-dir      = "$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)";
  common-config    = writeTextFile {
    name = "sway-common-config";
    text = ''
      output * background ${builtins.toString(./wallpaper.png)} fill
      set $print ${grim}/bin/grim \
        ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png') 
      ${builtins.readFile(../common-wm-config)}
      ${builtins.readFile(./sway-common-config)}
      ${lib.optionalString withScaling ''
        output * scale 2
        ${lib.optionalString withExtraPackages "xwayland scale 2"}
      ''}
      bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" \
        ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')
    '';
  };
  headless-config  = writeTextFile {
    name = "sway-headless-config";
    text = ''
      ${builtins.readFile(common-config)}
      ${builtins.readFile(./sway-headless-config)}
      exec ${wayvnc}/bin/wayvnc --keyboard=pl 0.0.0.0 5900
    '';
  };
  regular-config   = writeTextFile {
    name = "sway-config";
    text = ''
      ${builtins.readFile(common-config)}
      ${builtins.readFile(./sway-config)}
      ${additionalConfig}
      ${lib.optionalString withScaling "seat * xcursor_theme Paper 18"}
      exec --no-startup-id ${redshift-wayland'}/bin/redshift \
        -m wayland -l 51.12:17.05
      exec --no-startup-id ${mako}/bin/mako -c ${./mako-config}
      exec --no-startup-id mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob \
        | ${wob}/bin/wob
      exec ${swayidle}/bin/swayidle -w \
        timeout 300 'swaymsg "output * dpms off"' \
        resume 'swaymsg "output * dpms on"'
      bindsym $mod+BackSpace exec ${swaylock}/bin/swaylock
    '';
  };
  sway'            = sway.override {
    extraSessionCommands = builtins.readFile(./sway.sh);
    sway-unwrapped       = if withScaling && withExtraPackages
      then sway-unwrapped'' 
      else sway-unwrapped;
    withGtkWrapper       = true;
  };
  sway-unwrapped'  = sway-unwrapped.override { wlroots = wlroots'; };
  sway-unwrapped'' = sway-unwrapped'.overrideAttrs(old: rec {
    patches = old.patches ++ [(fetchpatch {
      url    = "https://github.com/swaywm/sway/pull/5090.patch";
      sha256 = "11zsjzsg2lnbq9nzr7q9bm1x98rcijbc9dbknd7zbpwbrg8hdw23";
    })];
    src     = fetchFromGitHub {
      owner  = "swaywm";
      repo   = "sway";
      rev    = "55016729a573a171a0faa20e0dec44e703da2c45";
      sha256 = "1ryja4bh7vzwr7cjl5zwzxd5ymbk87bhyrjay73p5whlxhysq1cp";
    };
  });
  wlroots'         = wlroots.overrideAttrs(old: rec {
    patches = [(fetchpatch {
      url = "https://github.com/swaywm/wlroots/pull/2064.patch";
      sha256 = "0jvfxyx1nbvzljhdxbjcn4739lda61mfzpznvk9i5hw1pclbck4w";
    })];
    src     = fetchFromGitHub {
      owner  = "swaywm";
      repo   = "wlroots";
      rev    = "1282c3b12fc2c0dacf0c5df9b261dfc45046e7c6";
      sha256 = "0iz1v9zf433vcry88l63mn387717lr2z7r3dasjykyiplf6kgm2n";
    };
  });
  xorgserver'      = xorgserver.overrideAttrs(old: rec {
    buildInputs       = old.buildInputs ++ [ fontutil utilmacros ];
    name              = "xorg-server-1.20.99";
    nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook ];
    src               = fetchgit {
      url    = "https://gitlab.freedesktop.org/dirbaio/xserver";
      rev    = "06224bd0c6f62ac9a8917100e504cb6659ece154";
      sha256 = "0vzkqgqfg3n3mxsaffzl231p72r7rbij4l19g84kipdl3gj6qzlx";
    };
  });
  xwayland'        = xwayland.override { xorgserver = xorgserver'; };
in symlinkJoin {
  name        = "sway";
  buildInputs = [ makeWrapper ];
  paths       = [ sway' ];
  postBuild   = ''
    mv $out/bin/sway $out/bin/sway-clean

    makeWrapper "$out/bin/sway-clean" $out/bin/sway \
      --add-flags "-c ${regular-config}" \
      --prefix PATH : ${bin-paths} ${lib.optionalString withExtraPackages '' \
        --prefix PATH : ${bin-paths-extra}
      ''}

    makeWrapper "$out/bin/sway-clean" $out/bin/sway-headless \
      --add-flags "-c ${headless-config}" \
      --set WLR_BACKENDS "headless" \
      --set WLR_LIBINPUT_NO_DEVICES 1 \
      --prefix PATH : ${bin-paths} ${lib.optionalString withExtraPackages '' \
        --prefix PATH : ${bin-paths-extra} \
      ''}
  '';
}
