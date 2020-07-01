{
  autoflake, autoreconfHook, bash-language-server, clang-tools, emacs,
  fetchFromGitHub, flake8, lib, makeWrapper, metals, pandoc, pytest,
  python-language-server, ripgrep, texinfo, symlinkJoin, wayland,
  wayland-protocols
}:

let emacs28 = emacs.overrideAttrs(old: {
  buildInputs       = old.buildInputs ++ [ wayland wayland-protocols ];
  configureFlags    = old.configureFlags ++ [
    "--without-x" "--with-cairo" "--with-modules"
  ];
  nativeBuildInputs = old.nativeBuildInputs ++ [ autoreconfHook texinfo ];
  patches           = [];

  src = fetchFromGitHub {
    owner  = "masm11";
    repo   = "emacs";
    rev    = "pgtk";
    sha256 = "0wbjf88hyl6b1ikqh1rfgaib5y0v6py6k6s1bgi1sqq4zf5afgsv";
  };
});
in symlinkJoin {
  buildInputs = [ makeWrapper ];
  name        = "emacs";
  paths       = emacs28;
  postBuild   = ''
    wrapProgram $out/bin/emacs \
      --prefix PATH : ${lib.makeBinPath[
        autoflake
        bash-language-server
        clang-tools
        flake8
        metals
        pandoc pytest python-language-server
        ripgrep
      ]} \
      --set PYLINTHOME "$HOME/.cache/pylint"
  '';
}
