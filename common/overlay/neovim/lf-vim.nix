{ fetchFromGitHub, lf-vim, vim-bbye }:

lf-vim.overrideAttrs(_: {
  dependencies = [ vim-bbye ];
  src          = fetchFromGitHub {
    owner  = "ptzz";
    repo   = "lf.vim";
    rev    = "cf3a56e126a6bf21f9004565d9b5043f1e9a093b";
    sha256 = "0vnh5xa5vwchsaz1a215pf0jyfc70sj31kvl1xmi867xks53jdgz";
  };
})
