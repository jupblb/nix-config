{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname   = "firenvim";
  version = "master";
  src     = fetchFromGitHub {
    owner  = "glacambre";
    repo   = "firenvim";
    rev    = version;
    sha256 = "sha256-4Zvcexh6a4qd78jkBqOWjr3J948kHbnnWjHhTLMsNpw=";
  };
}

