{ pkgs ? import <nixpkgs> {} }: pkgs.mkShell {
  buildInputs =
    let
      packages     = with pkgs; [ lua-language-server ];
      nodePackages = with pkgs.nodePackages; [ vim-language-server ];
    in packages ++ nodePackages;

  NVIM_LAZYDEV = "${pkgs.vimPlugins.lazydev-nvim}";
}
