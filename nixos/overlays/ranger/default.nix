{ atool, bat, catdoc, ffmpegthumbnailer, file,
  glow, imagemagick, jq, lib, makeWrapper,
  mediainfo, p7zip, pandoc, poppler_utils, ranger,
  symlinkJoin, unrar, xlsx2csv
}:

let
  ranger' = ranger.overrideAttrs(old: rec {
    preConfigure = ''
      substituteInPlace ranger/config/rc.conf --replace "#set preview_script ~/.config/ranger/scope.sh" "set preview_script ${./scope.sh}"
      substituteInPlace ranger/config/rc.conf --replace "map g? cd /usr/share/doc/ranger" "map g? cd $out/share/doc/ranger"
      substituteInPlace ranger/config/rc.conf --replace "set preview_images false" "set preview_images true"
      substituteInPlace ranger/config/rc.conf --replace "set preview_images_method w3m" "set preview_images_method kitty"
      substituteInPlace ranger/config/rc.conf --replace "set vcs_aware false" "set vcs_aware true"
    '';
  });
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "ranger";
  paths       = [ ranger' ];
  postBuild   = ''
    wrapProgram "$out/bin/ranger" \
      --prefix PATH : ${
        lib.makeBinPath [ atool bat catdoc ffmpegthumbnailer file glow imagemagick jq mediainfo p7zip pandoc poppler_utils unrar xlsx2csv ]
      } \
      --set BAT_THEME OneHalfLight \
      --set TERM xterm-kitty
  '';
}
