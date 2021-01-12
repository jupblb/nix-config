{ atool, bat, glow, jq, lib, poppler_utils, ranger }:

ranger.overrideAttrs(_: {
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ atool bat glow jq poppler_utils ]}"
  ];
  patches         = [ ./scope.patch ];
  preConfigure    = ''
    substituteInPlace ranger/config/rc.conf --replace \
      "set automatically_count_files true" \
      "set automatically_count_files false"
  '';
})
