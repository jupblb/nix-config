{ fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname   = "lsd";
  version = "0.17.1";

  src = fetchFromGitHub {
    owner  = "jupblb";
    repo   = pname;
    rev    = "02fe7dc678b97469e6f895fc0da42ff15c6e482d";
    sha256 = "1sgp1f3gnh53ixa69a4lk63g34j3ma3p8pyanisdfqd86h8804ky";
  };

  cargoSha256 = "1n22nfcvmry5bvqznwqfq833lc13avmgwnr6cpyx44iw5x9l68kd";
}
