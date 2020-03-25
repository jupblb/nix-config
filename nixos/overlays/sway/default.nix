{
  autoreconfHook, bemenu, ferdi', fetchFromGitHub, fetchgit, fetchpatch,
  firefox-wayland, fontutil, grim, i3status', idea-ultimate', imv, lib,
  makeWrapper, mako, mpv, pavucontrol, qutebrowser, redshift-wayland', slurp,
  symlinkJoin, sway, sway-unwrapped, utilmacros, wlroots, wob, writeTextFile,
  xdg-user-dirs, xorgserver, xwayland, zoom-us,

  withScaling ? false
}:

let
  picture-dir      = "$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)";
  sway-config      = writeTextFile {
    name = "config";
    text = ''
      exec --no-startup-id ${mako}/bin/mako -c ${./mako-config}
      exec --no-startup-id ${redshift-wayland'}/bin/redshift \
        -m wayland -l 51.12:17.05
      output * background ${builtins.toString(./wallpaper.png)} fill
      ${lib.optionalString withScaling "output * scale 2"}
      ${lib.optionalString withScaling "seat * xcursor_theme Paper 18"}
      ${lib.optionalString withScaling "xwayland scale 2"}
      set $browser ${qutebrowser}/bin/qutebrowser
      set $menu ${bemenu}/bin/bemenu-run --fn 'PragmataPro 12' -p "" \
        --fb '$bg' --ff '$fg' --hb '$green' --hf '$fg' --nb '$bg' --nf '$fg' \
        --sf '$bg' --sb '$fg' --tf '$fg' --tb '$bg' | xargs swaymsg exec --
      set $print ${grim}/bin/grim \
        ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png') 
      ${builtins.readFile(../common-wm-config)}
      ${builtins.readFile(./sway-config)}
      bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" \
        ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')
    '';
  };
  sway'            = sway.override {
    extraSessionCommands = builtins.readFile(./sway.sh);
    sway-unwrapped       = if withScaling then sway-unwrapped'' else sway-unwrapped;
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
    wrapProgram "$out/bin/sway" \
      --add-flags "-c ${sway-config}" \
      --prefix PATH : ${lib.makeBinPath[
        ferdi' firefox-wayland
        i3status' idea-ultimate' imv
        mpv
        pavucontrol
        wob
        xwayland'
        zoom-us
      ]}
  '';
}
