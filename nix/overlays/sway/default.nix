{
  bemenu, edid-generator, ferdi', fetchFromGitHub, fetchpatch, firefox-wayland,
  grim, i3status', idea-ultimate', imv, lib, makeWrapper, mako, mpv,
  pavucontrol, qutebrowser, redshift-wayland', slurp, symlinkJoin, sway,
  sway-unwrapped, swayidle, swaylock, wayvnc, wdisplays, wl-clipboard, wlroots',
  wob, writeTextFile, xdg-user-dirs, xwayland', zoom-us,

  withExtraPackages ? false,
  withScaling ? false
}:

let
  bin-paths = {
    common = lib.makeBinPath[
      bemenu firefox-wayland i3status' pavucontrol qutebrowser wl-clipboard
    ];
    extra  = lib.makeBinPath[
      ferdi' idea-ultimate' imv mpv xwayland' wdisplays zoom-us
    ];
  };
  config    = {
    common   =
      let
        picture-dir = "$(${xdg-user-dirs}/bin/xdg-user-dir PICTURES)";
      in writeTextFile {
        name = "sway-common-config";
        text = ''
          output * background ${builtins.toString(./wallpaper.png)} fill
          set $print ${grim}/bin/grim \
            ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png') 
          ${builtins.readFile(./sway-common-config)}
          ${lib.optionalString withScaling ''
            output * scale 2
            ${lib.optionalString withExtraPackages "xwayland scale 2"}
          ''}
          bindsym $mod+Print exec ${grim}/bin/grim -g "$(${slurp}/bin/slurp)" \
            ${picture-dir}/screenshots/$(date +'%F_%R:%S_grim.png')
        '';
    };
    headless = writeTextFile {
      name = "sway-headless-config";
      text = ''
        ${builtins.readFile(config.common)}
        ${builtins.readFile(./sway-headless-config)}
        exec ${wayvnc}/bin/wayvnc --keyboard=pl 0.0.0.0 5900
      '';
    };
    regular  = writeTextFile {
      name = "sway-config";
      text = ''
        ${builtins.readFile(config.common)}
        ${builtins.readFile(./sway-config)}
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
  };
  sway'     = 
    let
      sway-unwrapped'  = sway-unwrapped.override { wlroots = wlroots'; };
      sway-unwrapped'' = sway-unwrapped'.overrideAttrs(old: rec {
        patches = old.patches ++ [(fetchpatch {
          url    = "https://github.com/swaywm/sway/pull/5090.patch";
          sha256 = "11zsjzsg2lnbq9nzr7q9bm1x98rcijbc9dbknd7zbpwbrg8hdw23";
        })];
        src     = fetchFromGitHub {
          owner  = "swaywm";
          repo   = "sway";
          rev    = "2b15cf453e4b28324e9012515011a705c2960b30";
          sha256 = "0adqxdyr1w7s6js81p7px918s6kgr41l75pw4v8y1jxmnb1qbsw7";
        };
      });
    in sway.override {
      extraSessionCommands = builtins.readFile(./sway.sh);
      sway-unwrapped       = if withScaling && withExtraPackages
        then sway-unwrapped''
        else sway-unwrapped;
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
      --prefix PATH : ${bin-paths.common} ${optionalString withExtraPackages '' \
        --prefix PATH : ${bin-paths.extra}
      ''}

    makeWrapper "$out/bin/sway-clean" $out/bin/sway-headless \
      --add-flags "-c ${config.headless}" \
      --set WLR_BACKENDS "headless" \
      --set WLR_LIBINPUT_NO_DEVICES 1 \
      --prefix PATH : ${bin-paths.common} ${optionalString withExtraPackages '' \
        --prefix PATH : ${bin-paths.extra} \
      ''}
  '';
}
