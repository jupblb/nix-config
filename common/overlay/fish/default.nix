{ callPackage }:

{
  foreign-env = callPackage ./foreign-env.nix {};
  gruvbox     = callPackage ./gruvbox.nix {};
  kubectl     = callPackage ./kubectl.nix {};
  nix-env     = callPackage ./nix-env.nix {};
}
