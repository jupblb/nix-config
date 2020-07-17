{ fetchFromGitHub, fetchpatch, sway-unwrapped, wlroots }:

let
  sway-unwrapped' = sway-unwrapped.override { wlroots = wlroots'; };
  wlroots'        = wlroots.overrideAttrs(old: rec {
    patches = [ (fetchpatch {
      url    = "https://github.com/swaywm/wlroots/pull/2323.patch";
      sha256 = "197ryjw0wd4abs25gzjmrf5yjjp31ws2i0hmwjwqgv3i4dcxmhjy";
    }) ];
  });
in sway-unwrapped'.overrideAttrs(old: rec {
  patches = old.patches ++ [(fetchpatch {
    url    = "https://github.com/swaywm/sway/pull/5090.patch";
    sha256 = "131g9j02gbx0dsln6zp5fbr6vmvar11q2hbpq6dvfjlhj2ckxa4v";
  })];
})

