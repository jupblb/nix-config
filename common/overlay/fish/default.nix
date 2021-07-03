{ fetchurl, fish }:

fish.overrideAttrs(old: rec {
  src     = fetchurl {
    url    = let github = "https://github.com/fish-shell/fish-shell"; in
      "${github}/releases/download/${version}/${old.pname}-${version}.tar.xz";
    sha256 = "WUTaGoiT0RsIKKT9kTbuF0VJ2v+z0K392JF4Vv5rQAk=";
  };
  version = "3.2.2";
})
