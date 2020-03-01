{ diff-so-fancy, git, kitty, makeWrapper, neovim', symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "git";
  paths       = [ git ];
  postBuild   = ''
    wrapProgram "$out/bin/git" \
      --add-flags "-c include.path=~/.config/git/gitconfig.local" \
      --add-flags "-c color.ui=true" \
      --add-flags "-c core.editor=${neovim'}/bin/nvim" \
      --add-flags "-c core.excludesfile=${./gitignore}" \
      --add-flags "-c core.mergeoptions=--no-edit" \
      --add-flags "-c diff.tool=kitty" \
      --add-flags "-c difftool.kitty.cmd='${kitty}/bin/kitty +kitten diff --config=${./diff.conf} \$LOCAL \$REMOTE'" \
      --add-flags "-c difftool.prompt=false" \
      --add-flags "-c difftool.trustExitCode=true" \
      --add-flags "-c fetch.prune=true" \
      --add-flags "-c pager.diff='${diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX'" \
      --add-flags "-c pager.show='${diff-so-fancy}/bin/diff-so-fancy | less --tabs=1,5 -RFX'" \
      --add-flags "-c push.default=upstream" 
  '';
}
