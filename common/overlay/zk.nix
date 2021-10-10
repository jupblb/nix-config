{ buildGoModule, fetchFromGitHub, fetchurl, icu }:

buildGoModule rec {
  buildInputs  = [ icu ];
  doCheck      = false;
  pname        = "zk";
  preBuild     = ''buildFlagsArray+=("-tags" "fts5 icu")'';
  src          = fetchFromGitHub {
    owner  = "mickael-menu";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "0q0h0np26sq8ix831izr94il17bp75680plx9dvq27r5zzidazqb";
  };
  vendorSha256 = "12bq2hgd982wcl67bvzra19pfagv9rxivl6yn29vxvviqnzhdd4v";
  version      = "0.7.0";
}
