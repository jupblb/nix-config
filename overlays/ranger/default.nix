{
  atool, calibre, catdoc, fetchFromGitHub, ffmpegthumbnailer, file, fontforge,
  glow, imagemagick, jq, lib, makeWrapper, p7zip, pandoc, poppler_utils, ranger,
  symlinkJoin, unrar, xlsx2csv
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
      substituteInPlace ranger/config/rc.conf --replace \
        "set vcs_aware false" "set vcs_aware true"

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
        atool
        catdoc
        ffmpegthumbnailer file
        glow
        imagemagick
        jq
        p7zip poppler_utils
        unrar
        xlsx2csv
      ]}
  '';
}
