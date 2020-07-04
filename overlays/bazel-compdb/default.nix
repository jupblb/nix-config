{ bazel, fetchFromGitHub, makeWrapper, symlinkJoin }:

let bazel-compdb = fetchFromGitHub {
  owner  = "grailbio";
  repo   = "bazel-compilation-database";
  rev    = "master";
  sha256 = "0hnbxwdznk1igi5s51cykk76plyqap89pxmhsmjijma3ikfqyabb";
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
