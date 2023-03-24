self: super: with super; {
  calibre-web    = callPackage ./calibre-web { inherit (super) calibre-web; };
  pragmata-pro   = callPackage ./pragmata-pro {};
  nvidia-offload = callPackage ./nvidia-offload {};
}
