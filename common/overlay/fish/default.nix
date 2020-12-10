{ callPackage }:

{
  gruvbox    = callPackage ./gruvbox.nix {};
  nix-env    = callPackage ./nix-env.nix {};
  bobthefish = callPackage ./bobthefish.nix {};
}
