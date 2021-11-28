{ buildGoModule }:

buildGoModule rec {
  pname        = "jsonnet-language-server";
  src          = builtins.fetchGit {
    ref    = version;
    url    = "https://github.com/jdbaldry/jsonnet-language-server.git";
  };
  vendorSha256 = "sha256-8jX2we1fpVmjhwcaLZ584MdbkvnrcDNAw9xKhT/z740=";
  version      = "main";
}
