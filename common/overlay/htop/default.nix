{ fetchFromGitHub, htop }:

htop.overrideAttrs(_: {
  src = fetchFromGitHub {
    owner  = "KoffeinFlummi";
    repo   = "htop-vim";
    rev    = "3.0.3vim";
    sha256 = "0slkjg0flfgikn3sbqqf9azcm7na3mn6dqzqm9z3fwcc9wg3zjij";
  };
})
