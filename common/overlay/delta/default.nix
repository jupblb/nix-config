{ stdenv, lib, fetchFromGitHub, rustPlatform, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];
  cargoSha256 = "0pni6sal5nkcgyz24vfgzdkmn0vs63p5w2y1lhws7gpaaibh2hh7";
  pname       = "delta";
  src         = fetchFromGitHub {
    owner  = "dandavison";
    repo   = pname;
    rev    = "06e08b538b059e044c86150ecacc7a4794a20883";
    sha256 = "1wkl6fvvxsac3xagq44jkqdq9hhbc535ajha7212rfrzinaczh63";
  };
  version     = "0.4.4";
}
