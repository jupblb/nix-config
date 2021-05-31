{ compe-tabnine, fetchurl, stdenv, tabnine }:

let
  tabnine-version = builtins.readFile(fetchurl {
    url    = https://update.tabnine.com/bundles/version;
    sha256 = "18mzcw4lsbrbsap4fr22chsbpl775qkch3faq81726ag0z0dv01b";
  });
  tabnine'        = tabnine.overrideAttrs(_: {
    version = tabnine-version;
    src     =
      if stdenv.hostPlatform.system == "x86_64-darwin" then fetchurl {
        url    = "https://update.tabnine.com/bundles/${tabnine-version}/x86_64-apple-darwin/TabNine.zip";
        sha256 = "0lx4400ix1g7jlb4bkwmyyjh3dzhd7dz34bpc5gf6ycy3hvavk0m";
      }
      else if stdenv.hostPlatform.system == "x86_64-linux" then fetchurl {
        url    = "https://update.tabnine.com/bundles/${tabnine-version}/x86_64-unknown-linux-musl/TabNine.zip";
        sha256 = "06b9qvb50aj7418xghnd1vpdx5vci9dx8m52cq204ma8fsgqf0dw";
      }
      else throw "Not supported on ${stdenv.hostPlatform.system}";
  });
in compe-tabnine.overrideAttrs(_: {
  buildInputs = [ tabnine' ];

  postFixup = ''
    mkdir $target/binaries
    ln -s ${tabnine'}/bin/TabNine $target/binaries/TabNine_$(uname -s)
    ln -s ${tabnine'}/bin/TabNine-deep-* $target/binaries/
  '';
})
