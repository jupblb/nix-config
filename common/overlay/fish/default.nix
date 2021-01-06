{ callPackage }:

{
  foreign-env = callPackage ./foreign-env.nix {};
  gruvbox     = callPackage ./gruvbox.nix {};
  nix-env     = callPackage ./nix-env.nix {};
  bobthefish  = callPackage ./bobthefish.nix {};
}
