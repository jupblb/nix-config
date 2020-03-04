{ atool, bat, file, imagemagick, jq,
  lib, lynx, makeWrapper, mediainfo, poppler_utils,
  ranger, symlinkJoin
}:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "ranger";
  paths       = [ ranger ];
  postBuild   = ''
    wrapProgram "$out/bin/ranger" \
      --add-flags "--confdir=${builtins.toString ./.}" \
      --prefix PATH : ${lib.makeBinPath [ atool bat file imagemagick jq lynx mediainfo poppler_utils ]} \
      --set TERM xterm-kitty \
      --set BAT_THEME GitHub
  '';
}
