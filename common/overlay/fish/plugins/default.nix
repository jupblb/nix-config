{ callPackage }:

{
  gcloud  = callPackage ./gcloud.nix {};
  gruvbox = callPackage ./gruvbox.nix {};
  kubectl = callPackage ./kubectl.nix {};
  nix-env = callPackage ./nix-env.nix {};
}
