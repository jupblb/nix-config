self: pkgs: with pkgs; { 
  bazel-compdb' = callPackage ./bazel-compdb {};
  ranger'       = callPackage ./ranger {};
  sway'         = callPackage ./sway {};
}
