{ atool, bat, glow, jq, lib, poppler_utils, ranger }:

ranger.overrideAttrs(old: rec {
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ atool bat glow jq poppler_utils ]}"
  ];
  patches      = [ ./scope.patch ];
  preConfigure = ''
    substituteInPlace ranger/config/rc.conf --replace \
      "set automatically_count_files true" \
      "set automatically_count_files false"
    substituteInPlace ranger/config/rc.conf --replace \
      "set preview_images false" "set preview_images true"
    substituteInPlace ranger/config/rc.conf --replace \
      "set preview_images_method w3m" "set preview_images_method kitty"
  '';
})
