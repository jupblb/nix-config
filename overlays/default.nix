self: pkgs: with pkgs; { 
  ammonite'      = callPackage ./ammonite {};
  aws-cli'       = callPackage ./aws-cli {
    inherit(python3.pkgs) buildPythonApplication;
  };
  ferdi'         = callPackage ./ferdi {};
  idea-ultimate' = callPackage ./idea-ultimate {
    inherit(jetbrains) idea-ultimate jdk;
  };
  lsd'           = callPackage ./lsd {};
  ranger'        = callPackage ./ranger {};
  sway'          = callPackage ./sway {};
}
