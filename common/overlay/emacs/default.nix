{
  aspellWithDicts,
  cargo, ccls, clang, cmake,
  emacs,
  fd,
  gocode, gomodifytags, gopls, gore, gotests,
  jdk11, jq,
  lib,
  makeWrapper, mdl, metals,
  nixfmt, nodePackages,
  pandoc, pipenv, python3, python3Packages,
  ripgrep, rust-analyzer, rustc,
  shellcheck, symlinkJoin
}:

let
  aspell           = aspellWithDicts(d: with d; [
    en en-computers en-science
  ]);
  packages         = [
    aspell
    cargo ccls clang cmake
    fd
    gocode gomodifytags gopls gore gotests
    jdk11 jq
    mdl metals
    nixfmt
    pandoc pipenv python3
    ripgrep rust-analyzer rustc
    shellcheck
  ];
  nodePackages'    = with nodePackages; [
    bash-language-server
    js-beautify
    pyright
    stylelint
    typescript-language-server
    vscode-css-languageserver-bin vscode-html-languageserver-bin
    yaml-language-server
  ];
  python3Packages' = with python3Packages; [ isort nose pytest ];
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  meta        = emacs.meta;
  name        = "emacs-wrapped";
  paths       = [ emacs ];
  postBuild   = ''
    wrapProgram $out/bin/emacs \
      --prefix PATH : ${lib.makeBinPath(
        packages ++ nodePackages' ++ python3Packages'
      )}
  '';
  src         = emacs.src;
}
