{
  autoflake, autoreconfHook, bash-language-server, clang-tools, emacs,
  fetchFromGitHub, flake8, lib, makeWrapper, metals, pytest,
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
    sha256 = "1p6d3yq7x9kp275n58kzylcx2j64rkf4fmsqzirqw7lh7ki66y8m";
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
#       flake8
        metals
#       pytest python-language-server
        ripgrep
      ]}
  '';
}
