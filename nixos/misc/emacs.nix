{ cairo, emacs, fetchFromGitHub, makeWrapper, symlinkJoin }:

(emacs.override { srcRepo = true; }).overrideAttrs(old: {
  buildInputs       = old.buildInputs ++ [ cairo ];
  configureFlags    = old.configureFlags ++ [ "--with-cairo" "--with-pgtk" ];
  patches           = [];

  src = fetchFromGitHub {
    owner  = "masm11";
    repo   = "emacs";
    rev    = "pgtk";
    sha256 = "18fbdz9k17711bd7nd5yfkm3042vi50w9pippvaspzwrw0h7gv2z";
  };
})
