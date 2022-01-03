{ buildGoModule, fetchFromGitHub, icu }:

buildGoModule rec {
  pname        = "gtree";
  src          = fetchFromGitHub {
    owner  = "kitagry";
    repo   = pname;
    rev    = "${version}";
    sha256 = "0ldrl0rxs2nmxhagac68vdbd1w48f6i7cbbraaf5zzfb110famdl";
  };
  vendorSha256 = "0i2jx0dhzwci2w32sh3cynp30vm96ww7d3kmqhcpr0kf4dnavkhs";
  version      = "9711311";
}
