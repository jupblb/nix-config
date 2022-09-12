{ fetchFromGitHub, python3, vimUtils }:

let
  gkeepapi = python3.pkgs.buildPythonPackage rec {
    pname                 = "gkeepapi";
    propagatedBuildInputs = with python3.pkgs; [ future gpsoauth six ];
    src                   = fetchFromGitHub {
      owner  = "kiwiz";
      repo   = pname;
      rev    = version;
      sha256 = "sha256-frmNHPrYdGFNRsPQ3ZIS0kv4eIulHuSyjEPndu9CjdM=";
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
      sha256 = "sha256-bDtiGjEDI5La+LZnoGnEOvkZizo3PaTFL9bnnbw6rn0=";
    };
  };
in plugin.overrideAttrs(_: {
  passthru.python3Dependencies = ps: [ gkeepapi ps.keyring ];
})
