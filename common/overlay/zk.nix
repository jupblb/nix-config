{ buildGoModule, fetchFromGitHub, icu }:

buildGoModule rec {
  buildInputs  = [ icu ];
  doCheck      = false;
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
