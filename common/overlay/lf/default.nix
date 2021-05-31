{ callPackage, fetchurl, lf }:

(lf.overrideAttrs(_: { patches = [ ./user.patch ]; })) // {
  lfcd-fish = fetchurl {
    url    = https://raw.githubusercontent.com/gokcehan/lf/master/etc/lfcd.fish;
    sha256 = "16lagjvrm0wg7ddywv1l4l0b9cw8mvd7lfhyq6p454m93x15y4m3";
  };
  previewer = callPackage ./previewer.nix {};
}
