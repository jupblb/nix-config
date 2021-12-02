{ fetchFromGitHub, vimUtils }:

vimUtils.buildVimPlugin rec {
  pname     = "nvim-neoclip";
  src       = fetchFromGitHub {
    owner  = "AckslD";
    repo   = "nvim-neoclip.lua";
    rev    = version;
    sha256 = "1szwg804gajq84icl39gsmbqkaxh3yffdb50wh0pcgj86b4w5hda";
  };
  version   = "main";
}
