{ buildGoModule, fetchFromGitHub, fetchurl, icu }:

buildGoModule rec {
  buildInputs  = [ icu ];
  doCheck      = false;
  patches      = [ (fetchurl {
    url    = "https://github.com/mickael-menu/zk/commit/162bad446902332bb0f39c8d3911c3bc976a5d21.diff";
    sha256 = "1j3bnpw66w8kxi75zd399yvlz1hdcrj2faqxjy4kd3dkr340v2yg";
  }) ];
  pname        = "zk";
  preBuild     = ''buildFlagsArray+=("-tags" "fts5 icu")'';
  src          = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "01fxijs8faf06y58m3n23m18rnbmividirz21wablj56avdl4ibj";
  };
  vendorSha256 = "1dwcc20pd21y8w108zlw82jjwjif4yn4xbw4dhwk1jz5nssybzf0";
  version      = "0.6.0";
}
