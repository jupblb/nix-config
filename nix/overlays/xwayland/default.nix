{ autoreconfHook, fetchgit, fontutil, utilmacros, xorgserver, xwayland }:

let
  xorgserver' = xorgserver.overrideAttrs(old: rec {
    buildInputs       = old.buildInputs ++ [ fontutil utilmacros ];
    name              = "xorg-server-1.20.99";
    nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook ];
    src               = fetchgit {
      url    = "https://gitlab.freedesktop.org/dirbaio/xserver";
      rev    = "06224bd0c6f62ac9a8917100e504cb6659ece154";
      sha256 = "0vzkqgqfg3n3mxsaffzl231p72r7rbij4l19g84kipdl3gj6qzlx";
    };
  });
in xwayland.override { xorgserver = xorgserver'; } 
