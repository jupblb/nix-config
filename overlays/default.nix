self: pkgs: with pkgs; { 
  bazel-compdb' = callPackage ./bazel-compdb {};
  emacs'        = callPackage ./emacs {
    inherit(nodePackages) bash-language-server;
    inherit(python3Packages) flake8 pytest python-language-server;
  };
  lsd'          = callPackage ./lsd {};
  ranger'       = callPackage ./ranger {};
  sway'         = callPackage ./sway {};
}
