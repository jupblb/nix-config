{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  buildInputs = with pkgs.nodePackages; [ vim-language-server ];
}
