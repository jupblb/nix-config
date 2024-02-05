{ pkgs, ... }: {
  home.packages = with pkgs; [ flutter ];

  programs = {
    fish.plugins = [ {
      name = "flutter";
      src  = pkgs.callPackage ./fish.nix {};
    } ];

    neovim = {
      extraLuaConfig = "require('lspconfig').dartls.setup({})";
      extraPackages  = with pkgs; [ dart ];
    };

    vscode.userSettings = {
      "dart.addSdkToTerminalPath" = false;
      "dart.checkForSdkUpdates"   = false;
      "dart.devToolsTheme"        = "light";
      "dart.updateDevTools"       = false;
    };
  };
}
