{
  autoflake, bash-language-server, clang-tools, emacs-nox, flake8, lib,
  makeWrapper, metals, pandoc, pytest, python-language-server, python3, ripgrep,
  symlinkJoin
}:

in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "emacs";
  paths       = emacs-nox;
  postBuild   = ''
    wrapProgram $out/bin/emacs \
      --prefix PATH : ${lib.makeBinPath[
        autoflake
        bash-language-server
        clang-tools
        flake8
        metals
        pandoc pytest python-language-server python3
        ripgrep
      ]} \
      --set PYLINTHOME "$HOME/.cache/pylint"
  '';
}
