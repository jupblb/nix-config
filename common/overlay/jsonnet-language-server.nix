{ buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname        = "jsonnet-language-server";
  src          = fetchFromGitHub {
    owner  = "jdbaldry";
    repo   = pname;
    rev    = version;
    sha256 = "1hhah3kbq67j6zsyinnsirq77lf2i1500p200fz3djlb0cm6ri1l";
  };
  vendorSha256 = "sha256-8jX2we1fpVmjhwcaLZ584MdbkvnrcDNAw9xKhT/z740=";
  version      = "main";
}
