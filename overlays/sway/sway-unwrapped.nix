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
      url    = "https://github.com/swaywm/wlroots/pull/2064.patch";
      sha256 = "0gzaa6gdvrf3g4cn592pshhyrvr3ziz8sfbrswk461qrp1kxhv41";
    }) ];
    src        = fetchFromGitHub {
      owner  = "swaywm";
      repo   = "wlroots";
      rev    = "46c83cbf3daf6c38c70d0dcb5492e164b6c8ab29";
      sha256 = "015pidh69wcvh8y0v05q69p7d2jcwwpghv3hv0qxglb2jm726war";
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
    rev    = "52bd6aecf24af2aefc202d73aeef205cd62fa8b8";
    sha256 = "1vly3qz6mzpvwfxh5la73qz2cy800c1y9ly9dlqcz06pzw69cram";
  };
})
