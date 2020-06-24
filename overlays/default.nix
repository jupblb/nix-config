self: pkgs: with pkgs; { 
  ammonite'      = callPackage ./ammonite {};
  aws-cli'       = callPackage ./aws-cli {
    inherit(python3Packages) buildPythonApplication;
  };
  emacs'         = callPackage ./emacs {
    inherit(nodePackages) bash-language-server;
    inherit(python3Packages) flake8 pytest python-language-server;
  };
  ferdi'         = callPackage ./ferdi {};
  idea-ultimate' = callPackage ./idea-ultimate {
    inherit(jetbrains) idea-ultimate jdk;
  };
  lsd'           = callPackage ./lsd {};
  ranger'        = callPackage ./ranger {};
  sway'          = callPackage ./sway {};
}
