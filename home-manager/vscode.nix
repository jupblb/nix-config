{ config, pkgs, ... }: {
  home.packages = with pkgs;
    [ iosevka (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; }) ];

  fonts.fontconfig.enable = true;

  programs = {
    git.ignores = [ ".vscode" ];

    vscode = {
      enable               = true;
      extensions           = with pkgs.vscode-extensions; [];
      mutableExtensionsDir = true;
      package              = pkgs.vscode;
      userSettings         = {
        "breadcrumbs.enabled"             = false;
        "diffEditor.codeLens"             = true;
        "editor.fontFamily"               =
          "Iosevka, Symbols Nerd Font Mono, monospace";
        "editor.fontLigatures"            = true;
        "editor.fontSize"                 = 14;
        "editor.formatOnSave"             = true;
        "editor.minimap.enabled"          = false;
        "editor.rulers"                   = [ 80 120 ];
        "window.commandCenter"            = false;
        "workbench.activityBar.visible"   = false;
        "workbench.colorTheme"            = "Gruvbox Light Hard";
        "workbench.editor.showTabs"       = false;
        "workbench.statusBar.visible"     = false;

        # Flutter
        "dart.addSdkToTerminalPath" = false;
        "dart.checkForSdkUpdates"   = false;
        "dart.devToolsTheme"        = "light";
        "dart.updateDevTools"       = false;

        # Nix IDE
        "nix.enableLanguageServer" = true;
        "nix.serverPath"           = "${pkgs.nixd}/bin/nixd";

        # vim
        "vim.scroll"             = 16;
        "vim.smartRelativeLine"  = true;
        "vim.useSystemClipboard" = true;
        "vim.vimrc.enable"       = true;
        "vim.vimrc.path"         = "${toString ./neovim/config/init.vim}";
      };
    };
  };
}
