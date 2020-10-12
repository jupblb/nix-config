{ atool, glow, jq, lib, makeWrapper, poppler_utils, ranger, symlinkJoin }:

let
  ranger' = ranger.overrideAttrs(old: rec {
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
  });
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "ranger";
  paths       = [ ranger' ];
  postBuild   = ''
    wrapProgram "$out/bin/ranger" \
      --prefix PATH : ${lib.makeBinPath [ atool glow jq poppler_utils ]}
  '';
}
