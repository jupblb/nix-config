{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  dontBuild = true;
  pname     = "venn-nvim";
  version   = "main";
  src       = fetchFromGitHub {
    owner  = "jbyuki";
    repo   = "venn.nvim";
    rev    = version;
    sha256 = "1mzxvx1vqnm89yzzy6n3s30y9w7s38lbjhnwdf4diy0kdzyq8x06";
  };
}
