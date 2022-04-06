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
    sha256 = "1r22x33n55c6br9kmc9hlly2b5g7bnc122g3h072akwm0chcnfh5";
  };
}
