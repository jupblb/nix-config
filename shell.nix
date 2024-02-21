{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs =
    let
      pkgs'    = with pkgs; [ lua-language-server nil ];
      nodePkgs = with pkgs.nodePackages; [ vim-language-server ];
    in pkgs' ++ nodePkgs;
}
