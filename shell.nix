{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  buildInputs =
    let
      agenixTarball = builtins.fetchTarball
        "https://github.com/ryantm/agenix/archive/main.tar.gz";
      agenix        = pkgs.callPackage("${agenixTarball}/pkgs/agenix.nix"){};
      packages      = with pkgs; [ lua-language-server ];
      nodePackages  = with pkgs.nodePackages; [ vim-language-server ];
    in [ agenix ] ++ packages ++ nodePackages;

  NVIM_LAZYDEV = "${pkgs.vimPlugins.lazydev-nvim}";
}
