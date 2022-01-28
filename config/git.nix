{
  aliases     = {
    amend = "commit --amend --no-edit";
    line  = "!sh -c 'git log -L$2,+1:\${GIT_PREFIX:-./}$1' -";
    lines = "!sh -c 'git log -L$2,$3:\${GIT_PREFIX:-./}$1' -";
  };
  delta       = {
    enable  = true;
    options = {
      line-numbers            = true;
      minus-emph-style        = "syntax #fa9f86";
      minus-style             = "syntax #f9d8bc";
      plus-emph-style         = "syntax #d9d87f";
      plus-style              = "syntax #eeebba";
      side-by-side            = true;
      syntax-theme            = "gruvbox-light";
    };
  };
  enable      = true;
  extraConfig = {
    color.ui            = true;
    core.mergeoptions   = "--no-edit";
    fetch.prune         = true;
    merge.conflictStyle = "diff3";
    pull.rebase         = true;
    push.default        = "upstream";
    submodule.recurse   = true;
  };
  ignores     = [ ".vim-bookmarks" ];
  signing     = { key = "1F516D495D5D8D5B"; signByDefault = true; };
  userEmail   = "mpkielbowicz@gmail.com";
  userName    = "jupblb";
}
