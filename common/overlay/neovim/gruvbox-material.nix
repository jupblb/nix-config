{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "gruvbox-material-nvim";
  version   = "master";
  src       = fetchFromGitHub {
    owner  = "sainnhe";
    repo   = "gruvbox-material";
    rev    = version;
    sha256 = "1pvdlci25qr122gzrb661bpl62sfz81vxsbyzwwnf16b18qsxi5r";
  };
}

