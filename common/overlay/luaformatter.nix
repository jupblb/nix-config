{ cmake, fetchFromGitHub, gccStdenv }:

gccStdenv.mkDerivation rec {
  installPhase      = ''
    runHook preInstall
    mkdir -p $out/bin
    cp lua-format $out/bin
    runHook postInstall
  '';
  nativeBuildInputs = [ cmake ];
  pname             = "luaformatter";
  src               = fetchFromGitHub {
    owner           = "koihik";
    repo            = "luaformatter";
    rev             = version;
    sha256          = "0440kdab5i0vhlk71sbprdrhg362al8jqpy7w2vdhcz1fpi5cm0b";
    fetchSubmodules = true;
  };
  version           = "1.3.6";
}
