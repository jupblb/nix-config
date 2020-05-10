{ makeWrapper, pkgs, symlinkJoin, sway, writeTextFile }:

let
  path   = with pkgs; lib.makeBinPath [
    wdisplays wl-clipboard xsettingsd (callPackage ./xwayland.nix {})
  ];
  config = {
    common   = with pkgs; callPackage ./sway-config.nix {};
    headless = writeTextFile {
      name = "sway-config-headless";
      text = with pkgs; ''
        ${config.common}
        exec ${wayvnc}/bin/wayvnc --keyboard=pl
        seat seat0 keyboard_grouping none
      '';
    };
    regular  = writeTextFile {
      name = "sway-config";
      text = with pkgs; ''
        ${config.common}
        exec --no-startup-id ${redshift-wlr}/bin/redshift \
          -m wayland -l 51.12:17.05
        exec ${swayidle}/bin/swayidle -w \
          timeout 300 '${swaylock}/bin/swaylock' \
          timeout 360 'swaymsg "output * dpms off"' \
               resume 'swaymsg "output * dpms on"' \
          before-sleep '${swaylock}/bin/swaylock'
        bindsym $mod+BackSpace exec ${swaylock}/bin/swaylock
      '';
    };
  };
  sway'  = sway.override {
    extraSessionCommands = builtins.readFile ./sway.sh;
    sway-unwrapped       = with pkgs; callPackage ./sway-unwrapped.nix {};
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
