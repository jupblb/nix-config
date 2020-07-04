{ bazel, fetchFromGitHub, makeWrapper, symlinkJoin }:

let bazel-compdb = fetchFromGitHub {
  owner  = "grailbio";
  repo   = "bazel-compilation-database";
  rev    = "0.4.4";
  sha256 = "13wgwzc6g22xv8wqi7iqvl42qlgyk11144l1hn5aw2acwm7dza9c";
};
in symlinkJoin {
  name        = "bazel-compdb";
  buildInputs = [ makeWrapper ];
  paths       = [ bazel-compdb ];
  postBuild   = ''
    sed -i 's/bin\/bash/usr\/bin\/env bash/g' $out/generate.sh
    makeWrapper $out/generate.sh $out/bin/bazel-compdb \
      --prefix PATH : ${bazel}/bin
  '';
}
