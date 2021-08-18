{ fetchFromGitHub, mdformat-tables, python3Packages }:

with python3Packages; buildPythonPackage rec {
  buildInputs           = [ mdformat mdformat-tables ];
  checkInputs           = [ pytestCheckHook ];
  format                = "pyproject";
  nativeBuildInputs     = [ poetry-core ];
  pname                 = "mdformat-gfm";
  propagatedBuildInputs = [ markdown-it-py mdit-py-plugins mdformat-tables ];
  src                   = fetchFromGitHub {
    owner  = "hukkin";
    repo   = pname;
    rev    = version;
    sha256 = "0gl3zj80pdnh630rd93c8lzj02hh493w6ja1ax64vb6qcd40562y";
  };
  version               = "0.3.2";
}
