{ pkgs, ... }: {
  home = {
    packages         = with pkgs; [ gore ];
    sessionVariables = { GOROOT = "${pkgs.go}/share/go"; };
  };

  programs = {
    go     = {
      enable = true;
      goPath = ".cache/go";
    };
    neovim = {
      extraLuaConfig = ''
        require('lspconfig').gopls.setup({
            settings = { gopls = { gofumpt = true, staticcheck = true } }
        })
      '';
      extraPackages  = with pkgs; [ gopls ];
    };
  };
}
