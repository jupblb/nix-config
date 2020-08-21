{
  atool, catdoc, fetchFromGitHub, file, glow, imagemagick, jq, lib, makeWrapper,
  poppler_utils, ranger, symlinkJoin, xlsx2csv
}:

let
  ranger' = ranger.overrideAttrs(old: rec {
    patches      = [ ./scope.patch ];
    preConfigure = ''
      substituteInPlace ranger/config/rc.conf --replace \
        "map g? cd /usr/share/doc/ranger" "map g? cd $out/share/doc/ranger"
      substituteInPlace ranger/config/rc.conf --replace \
        "set preview_images false" "set preview_images true"
      substituteInPlace ranger/config/rc.conf --replace \
        "set preview_images_method w3m" "set preview_images_method kitty"
      echo "default_linemode devicons" >> ranger/config/rc.conf
    '';
  });
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "ranger";
  paths       = [ ranger' ];
  postBuild   = ''
    wrapProgram "$out/bin/ranger" \
      --add-flags "--confdir=${builtins.toString ./.}" \
      --prefix PATH : ${lib.makeBinPath [
        atool catdoc file glow imagemagick jq poppler_utils xlsx2csv
      ]} \
      --set-default LC_ALL "C" \
      --set-default LC_CTYPE "en_US.UTF-8"
  '';
}
