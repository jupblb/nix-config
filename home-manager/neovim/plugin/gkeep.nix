{ fetchFromGitHub, python3, vimUtils }:

let
  gkeepapi = python3.pkgs.buildPythonPackage rec {
    pname                 = "gkeepapi";
    propagatedBuildInputs = with python3.pkgs; [ future gpsoauth six ];
    src                   = fetchFromGitHub {
      owner  = "kiwiz";
      repo   = pname;
      rev    = version;
      sha256 = "10f89n4hcv545rnk7n2yhq141wzflh2jgjc5smm9h4nsn0p8fywv";
    };
    version = "master";
  };
  plugin = vimUtils.buildVimPlugin rec {
    pname   = "gkeep-nvim";
    version = "master";
    src     = fetchFromGitHub {
      owner  = "stevearc";
      repo   = "gkeep.nvim";
      rev    = version;
      sha256 = "1i1nyf57bcwxg732ph0l6y4msglssp7krq64vfzwbh9i0zpl4afv";
    };
  };
in plugin.overrideAttrs(_: {
  passthru.python3Dependencies = ps: [ gkeepapi ps.keyring ];
})