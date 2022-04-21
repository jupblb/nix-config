{ bashInteractive, delta, fetchFromGitHub, makeWrapper, stdenv }:

stdenv.mkDerivation rec {
  buildInputs  = [ makeWrapper ];
  installPhase = ''
    cp -r . $out
    wrapProgram $out/bin/git-forgit \
      --set FORGIT_INSTALL_DIR $out
  '';
  name         = "forgit";
  src          = fetchFromGitHub {
    owner  = "wfxr";
    repo   = name;
    rev    = "master";
    sha256 = "1hq1qbpfj0kfld8rvqf7mhh83mll6baq26p1cp0sr68cf66nl51q";
  };
}
