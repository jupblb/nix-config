{ buildPythonApplication, fetchFromGitHub, groff, lib, python3 }:

let python3' = python3.override {
      packageOverrides = self: super: {
        botocore      = super.botocore.overridePythonAttrs(old: rec {
          src     = fetchFromGitHub {
            owner  = "boto";
            repo   = "botocore";
            rev    = "ce7b76d296b345d7647f50557606947ad857a786";
            sha256 = "0g9pvcs94v2znjkzzjnz30021q9bm97fxmlhxvql6im3c6adrqb3";
          };
          version = "2.0.0dev19";
        });
        prompt_toolkit = super.prompt_toolkit.overridePythonAttrs(old: rec {
          src     = old.src.override {
            inherit version;
            sha256 = "1nr990i4b04rnlw1ghd0xmgvvvhih698mb6lb6jylr76cs7zcnpi";
          };
          version = "2.0.10";
        });
      };
    };
in buildPythonApplication rec {
  doCheck = false;

  passthru.python = python3';

  pname = "aws-cli";

  postPatch = ''
    substituteInPlace setup.py --replace ",<0.16" ""
    substituteInPlace setup.py --replace "cryptography>=2.8.0,<=2.9.0" "cryptography>=2.8.0,<2.10"
  '';

  propagatedBuildInputs = with python3'.pkgs; [
    botocore bcdoc
    colorama cryptography
    docutils
    groff
    s3transfer six
    prompt_toolkit pyyaml
    rsa ruamel_yaml
  ];

  src = fetchFromGitHub {
    owner  = "aws";
    repo   = "aws-cli";
    rev    = version;
    sha256 = "030pw7aa1y13awrpwlsq3ib633fh1z4rzkz8b31x7jg7s1hxrsvr";
  };

  version = "2.0.15";
}
