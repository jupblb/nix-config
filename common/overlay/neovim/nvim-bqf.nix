{ fetchFromGitHub, nvim-bqf }:

nvim-bqf.overrideAttrs(_: {
  src = fetchFromGitHub {
    owner  = "kevinhwang91";
    repo   = "nvim-bqf";
    rev    = "b4c1294cdc999823a0d61f20a5132f0a230b9a44";
    sha256 = "0l252jly2p9s42xjxkxs6mh7yjmnd3nwbswcan8y73limgc0vzkk";
  };
})
