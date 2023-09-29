{ pkgs, ... }: {
  home.packages = with pkgs; [ flutter ];

  programs = {
    fish.plugins = [ {
      name = "flutter";
      src  = pkgs.callPackage ./fish.nix {};
    } ];

    vscode.userSettings = {
      "dart.addSdkToTerminalPath" = false;
      "dart.checkForSdkUpdates"   = false;
      "dart.devToolsTheme"        = "light";
      "dart.updateDevTools"       = false;
    };
  };
}
