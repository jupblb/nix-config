_: {
  programs.firefox = {
    enable                        = true;
    profiles."jupblb".settings    = {
      "browser.aboutConfig.showWarning"          = false;
      "browser.toolbars.bookmarks.visibility"    = "never";
      "extensions.pocket.enabled"                = false;
      "full-screen-api.warning.timeout"          = 0;
      "network.protocol-handler.expose.magnet"   = false;
      "permissions.default.desktop-notification" = 2;
    };
  };

  xdg.configFile = {
    "tridactyl/tridactylrc".text = builtins.readFile ./tridactylrc.vim;
  };
}
