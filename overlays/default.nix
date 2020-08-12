self: pkgs: with pkgs; { 
  ranger'       = callPackage ./ranger {};
  sway'         = callPackage ./sway {};
}
