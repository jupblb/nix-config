{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname        = "test-infra";
  src          = fetchFromGitHub {
    owner  = "kubernetes";
    repo   = pname;
    rev    = "2413abc0f489231f1cefcbc38c320e6910c6e7c4";
    sha256 = "1h2r97iklclci25m6mbgj7sr6377hfbr6bm8c1irbgkjiakl35ci";
  };
  subPackages  = [ "prow/cmd/mkpj" ];
  vendorSha256 = "0vb4zbiba6dznc9q41nk0676nfspj3a3xn35119s3i06d19ns0cf";
  version      = "2020-07-04";
}
