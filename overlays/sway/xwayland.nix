{ autoreconfHook, fetchgit, fontutil, utilmacros, xorgserver, xwayland }:

let xorgserver' = xorgserver.overrideAttrs(old: rec {
      buildInputs       = old.buildInputs ++ [ fontutil utilmacros ];
      name              = "xorg-server-1.20.99";
      nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook ];
      src               = fetchgit {
        url    = "https://gitlab.freedesktop.org/dirbaio/xserver";
        rev    = "30ea6cb622e9bdbc75f74705d0e1cdf7355d5a80";
        sha256 = "1jc30ipgzr9m5jgb8gwlp9qsl0bd6z35c0hvbbzypfa942rcs18w";
      };
    });
in xwayland.override { xorgserver = xorgserver'; } 
