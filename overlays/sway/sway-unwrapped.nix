{ fetchFromGitHub, fetchpatch, sway-unwrapped, wlroots }:

let
  sway-unwrapped' = sway-unwrapped.override { wlroots = wlroots'; };
  wlroots'        = wlroots.overrideAttrs(old: rec {
    mesonFlags = [
      "-Dlibcap=enabled"
      "-Dlogind-provider=systemd"
      "-Dx11-backend=enabled"
      "-Dxcb-errors=enabled"
      "-Dxcb-icccm=enabled"
      "-Dxcb-xkb=enabled"
      "-Dxwayland=enabled"
    ];
    patches    = [ (fetchpatch {
      url    = "https://github.com/swaywm/wlroots/pull/2323.patch";
      sha256 = "197ryjw0wd4abs25gzjmrf5yjjp31ws2i0hmwjwqgv3i4dcxmhjy";
    }) ];
    src        = fetchFromGitHub {
      owner  = "swaywm";
      repo   = "wlroots";
      rev    = "a54ed8588177a679a131c621c0d300c6a9d910c5";
      sha256 = "1ck5wrw8xl2ss1qixlmspsix7a96abajvl9v3xcygxmrnkj6412v";
    };
  });
in sway-unwrapped'.overrideAttrs(old: rec {
  patches = old.patches ++ [(fetchpatch {
    url    = "https://github.com/swaywm/sway/pull/5090.patch";
    sha256 = "131g9j02gbx0dsln6zp5fbr6vmvar11q2hbpq6dvfjlhj2ckxa4v";
  })];
  src     = fetchFromGitHub {
    owner  = "swaywm";
    repo   = "sway";
    rev    = "v1.5-rc2";
    sha256 = "1a2fi11zw2k9jn8ri4byjm87d7w1l52dbjn1l4476f3fnj7ga1z5";
  };
})
