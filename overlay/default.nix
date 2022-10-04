self: super: with super; {
  calibre-web   = callPackage ./calibre-web { inherit (super) calibre-web; };
  neovim-remote = super.neovim-remote.overrideAttrs(_: {
    # https://github.com/NixOS/nixpkgs/pull/194108
    patches = [
      (fetchpatch {
        url = "https://github.com/mhinz/neovim-remote/commit/56d2a4097f4b639a16902390d9bdd8d1350f948c.patch";
        hash = "sha256-/PjE+9yfHtOUEp3xBaobzRM8Eo2wqOhnF1Es7SIdxvM=";
      })
    ];
    preCheck = ''
      export HOME="$(mktemp -d)"
    '';
  });
  pragmata-pro  = callPackage ./pragmata-pro {};
}
