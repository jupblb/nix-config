{ fetchFromGitHub, python3Packages }:

with python3Packages; buildPythonPackage rec {
  buildInputs       = [ flit-core mdformat ];
  checkInputs       = [ pytestCheckHook tox ];
  format            = "pyproject";
  nativeBuildInputs = [ poetry-core ];
  pname             = "mdformat-tables";
  src               = fetchFromGitHub {
    owner  = "executablebooks";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "014xfq11arczhni0bd2l66gg9qb40b24gwk8yihi53viljcldba3";
  };
  version           = "0.4.1";
}
