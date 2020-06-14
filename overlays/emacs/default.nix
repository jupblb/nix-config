{
  autoreconfHook, emacs, fetchFromGitHub, lib, wayland, wayland-protocols,
  texinfo
}:
emacs.overrideAttrs(old: {
  buildInputs       = old.buildInputs ++ [ wayland wayland-protocols];
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
})
