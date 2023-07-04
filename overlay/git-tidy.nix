{ buildRustPackage, fetchFromGitHub }: buildRustPackage rec {
  cargoHash = "sha256-wmKDsaTTk5roRqpPsj6Nx4n015sSqAQTlJ9Z+QGYbAM=";
  pname     = "git-tidy";
  src       = fetchFromGitHub {
    owner = "drewwyatt";
    repo  = pname;
    rev   = "v${version}";
    hash  = "sha256-b9uUILsR5OHzWo/Q1Coe15YlR3shx3ZHyv+9SS9clDU=";
  };
  version   = "2.0.1";
}
