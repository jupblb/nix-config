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
    sha256 = "16xgrhp88sghgzak8k9ja25n786f6205mw3x1ak9bbg43n63jf4m";
  };
  vendorSha256 = "12bq2hgd982wcl67bvzra19pfagv9rxivl6yn29vxvviqnzhdd4v";
  version      = "0.8.0";
}
