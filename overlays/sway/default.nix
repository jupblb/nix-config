{
  bemenu, callPackage, discord, grim, imv, lib, makeWrapper, mako, mpv,
  pavucontrol, qutebrowser, redshift-wlr, remmina, slurp, sway, swaylock,
  symlinkJoin, wayvnc, wdisplays, wl-clipboard, wob, writeScriptBin,
  writeTextFile, xdg-user-dirs
}:

let
  path   = lib.makeBinPath [
    discord imv mpv pavucontrol remmina wdisplays wl-clipboard
  ];
  config = {
    common   = callPackage ./sway-config.nix {};
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
        bindsym $mod+BackSpace exec ${swaylock}/bin/swaylock
      '';
    };
  };
  sway'  = sway.override {
    extraSessionCommands = builtins.readFile ./sway.sh;
    withGtkWrapper       = true;
  };
in symlinkJoin {
  name        = "sway";
  buildInputs = [ makeWrapper ];
  paths       = [ sway' ];
  postBuild   = ''
    mv $out/bin/sway $out/bin/sway-clean

    makeWrapper "$out/bin/sway-clean" $out/bin/sway \
      --add-flags "-c ${config.regular}" \
      --prefix PATH : ${path}

    makeWrapper "$out/bin/sway-clean" $out/bin/sway-headless \
      --add-flags "-c ${config.headless}" \
      --prefix PATH : ${path} \
      --set WLR_BACKENDS "headless" \
      --set WLR_LIBINPUT_NO_DEVICES 1
  '';
}
