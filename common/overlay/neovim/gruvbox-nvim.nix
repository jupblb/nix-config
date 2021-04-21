{ fetchFromGitHub, lush-nvim, vimUtils }:

vimUtils.buildVimPlugin rec {
  dependencies = [ lush-nvim ];
  pname        = "gruvbox-nvim";
  src = fetchFromGitHub {
    owner  = "npxbr";
    repo   = "gruvbox.nvim";
    rev    = version;
    sha256 = "0y2w4w4dqnffyhc955770327q4vayb65r295zf7pd1sirgpbd05q";
  };
  version      = "main";
}
