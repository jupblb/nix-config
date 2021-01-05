{ emacs, fd, lib, makeWrapper, pandoc, ripgrep, shellcheck, symlinkJoin }:

symlinkJoin {
  name        = "emacs-wrapped";
  buildInputs = [ makeWrapper ];
  meta        = emacs.meta;
  paths       = [ emacs ];
  postBuild   = ''
    wrapProgram $out/bin/emacs \
      --prefix PATH : ${lib.makeBinPath [ fd pandoc ripgrep shellcheck ]}
  '';
  src         = emacs.src;
}
