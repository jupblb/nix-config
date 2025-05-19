{ fetchFromGitHub, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname     = "fish-ai";
  version   = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Realiserad";
    repo  = "fish-ai";
    rev   = "v${version}";
    hash  = "sha256-SywATcha9xvxr6dwMZqXWfFTydriHAGU3sjkBQYmSg4=";
  };

  # Skip checking for unused model dependencies
  dontCheckRuntimeDeps = true;
  pythonImportsCheck   = [ "fish_ai" ];

  build-system = with python3Packages; [ setuptools ];
  dependencies = with python3Packages; [
    binaryornot cohere google-genai iterfzf keyring simple-term-menu
  ];
}
