{ fetchFromGitHub, lush-nvim, vimUtils }:

vimUtils.buildVimPlugin rec {
  dependencies = [ lush-nvim ];
  pname        = "gruvbox-nvim";
  src = fetchFromGitHub {
    owner  = "npxbr";
    repo   = "gruvbox.nvim";
    rev    = version;
    sha256 = "04d8knfhidxdm8lzc15hklq1mm6i5kmdkik4iln4cbhd3cg33iqy";
  };
  version      = "main";
}
