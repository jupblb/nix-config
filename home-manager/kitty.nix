{ config, pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
      (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    ];
    shellAliases = {
      icat = "kitty +kitten icat";
      ssh  = "kitty +kitten ssh";
    };
  };

  programs = {
    kitty = {
      enable      = true;
      font        = {
        name = "Iosevka Term";
        size = 10;
      };
      keybindings = {
        "ctrl+shift+0"     = "change_font_size all 0";
        "ctrl+shift+'"     = "launch --location=hsplit";
        "ctrl+shift+j"     = "move_window bottom";
        "ctrl+shift+h"     = "move_window left";
        "ctrl+shift+l"     = "move_window right";
        "ctrl+shift+k"     = "move_window top";
        "ctrl+shift+t"     = "new_tab_with_cwd";
        "ctrl+shift+enter" = "new_window_with_cwd";
        "ctrl+h"           = "neighboring_window left";
        "ctrl+j"           = "neighboring_window bottom";
        "ctrl+k"           = "neighboring_window top";
        "ctrl+l"           = "neighboring_window right";
        "ctrl+shift+`"     = "show_scrollback";
      };
      settings    = {
        clipboard_control             =
          "write-clipboard write-primary no-append";
        confirm_os_window_close       = 0;
        cursor_blink_interval         = 0;
        enabled_layouts               = "splits";
        enable_audio_bell             = "no";
        hide_window_decorations       = "yes";
        scrollback_pager_history_size = 4096;
        # https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font
        symbol_map                    =
          let mappings = [
            "U+23FB-U+23FE" "U+2B58" "U+E200-U+E2A9" "U+E0A0-U+E0A3"
            "U+E0B0-U+E0BF" "U+E0C0-U+E0C8" "U+E0CC-U+E0CF" "U+E0D0-U+E0D2"
            "U+E0D4" "U+E700-U+E7C5" "U+F000-U+F2E0" "U+2665" "U+26A1"
            "U+F400-U+F4A8" "U+F67C" "U+E000-U+E00A" "U+F300-U+F313"
            "U+E5FA-U+E62B"
          ];
          in (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
        tab_bar_min_tabs              = 5;
      };
      themeFile   = "gruvbox-light-hard";
    };

    vscode.userSettings = {
      "terminal.external.linuxExec" =
        "${config.programs.kitty.package}/bin/kitty";
      "terminal.external.osxExec"   =
        "${config.programs.kitty.package}/Applications/kitty.app";
    };
  };
}

