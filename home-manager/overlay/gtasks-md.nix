{ gnused, pandoc, pandoc-types, python3Packages, writeText }:

let python-pandoc = with python3Packages; buildPythonPackage rec {
  pname                 = "pandoc";
  postPatch             = ''
    # Skip checks for Pandoc version
    ${gnused}/bin/sed -e '122,125d' -i src/pandoc/__init__.py
    ${gnused}/bin/sed -e '59,62d' -i src/pandoc/utils.py
  '';
  propagatedBuildInputs = [ plumbum ply ];
  src                   = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LfsXvAVGkHbJfB20wIqFIKP3awhuJuMtAf5OQIryroc=";
  };
  version               = "2.4b0";
};
in with python3Packages; buildPythonApplication rec {
  doCheck               = false;
  pname                 = "gtasks-md";
  postPatch             =
    let pandocConfig = writeText "pandoc-py-config" ''
      import pandoc

      pandoc.configure(
        auto                 = False,
        path                 = "${pandoc}/bin/pandoc",
        version              = "${pandoc.version}",
        pandoc_types_version = \
          "${lib.versions.majorMinor pandoc-types.version}",
      )
    '';
    in "cat ${pandocConfig} >> app/__init__.py";
  propagatedBuildInputs = [
    google-api-python-client
    google-auth-httplib2
    google-auth-oauthlib
    pandoc
    python-pandoc
    setuptools
    xdg
  ];
  src                   = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bsLg1tgFmct30350OKI4VCf3W041m9JG7zbRW5OlI48=";
  };
  version               = "0.0.9";
}
