{ fetchFromGitHub, fetchpatch, wlroots }:

wlroots.overrideAttrs(old: rec {
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
    sha256 = "0jvfxyx1nbvzljhdxbjcn4739lda61mfzpznvk9i5hw1pclbck4w";
  }) ];
  src        = fetchFromGitHub {
    owner  = "swaywm";
    repo   = "wlroots";
    rev    = "85e299e6c55e5478617cb167eea316cfe7ee430c";
    sha256 = "13yhq96lglx16j8v11dfr43779ibn9z6f673w7jkq9lm06cp91qj";
  };
})
