{ fetchFromGitHub, plenary-nvim, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild    = true;
  dependencies = [ plenary-nvim ];
  pname        = "nvim-metals";
  version      = "main";
  src          = fetchFromGitHub {
    owner  = "scalameta";
    repo   = pname;
    rev    = version;
    sha256 = "0dc83br7var5ksdhz4pdym8yhkx60vi1z2qb58gf7v2cn8ivribh";
  };
}
