{ diff-so-fancy, git, lib, makeWrapper, symlinkJoin }:

symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "git";
  paths       = [ git ];
  postBuild   = ''
    wrapProgram "$out/bin/git" \
      --add-flags "-c include.path=~/.config/git/gitconfig.local" \
      --add-flags "-c color.ui=true" \
      --add-flags "-c core.excludesfile=${./gitignore}" \
      --add-flags "-c core.mergeoptions=--no-edit" \
      --add-flags "-c fetch.prune=true" \
      --add-flags "-c pager.diff='diff-so-fancy | less --tabs=1,5 -RFX'" \
      --add-flags "-c pager.show='diff-so-fancy | less --tabs=1,5 -RFX'" \
      --add-flags "-c push.default=upstream" \
      --prefix PATH : ${lib.makeBinPath[ diff-so-fancy ]}
  '';
}
