{ buildGoModule, fetchFromGitHub, icu }:

buildGoModule rec {
  pname        = "gtree";
  src          = fetchFromGitHub {
    owner  = "kitagry";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1914swyja01kiyq6857by7vyra6y0v5q8iw1ch9aknsqb3pnlzqf";
  };
  vendorSha256 = "0i2jx0dhzwci2w32sh3cynp30vm96ww7d3kmqhcpr0kf4dnavkhs";
  version      = "0.2.1";
}
