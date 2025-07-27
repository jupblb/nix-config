{ pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      (iosevka-bin.override { variant = "SGr-IosevkaTerm"; })
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
            "U+e000-U+e00a" "U+ea60-U+ebeb" "U+e0a0-U+e0c8" "U+e0ca"
            "U+e0cc-U+e0d7" "U+e200-U+e2a9" "U+e300-U+e3e3" "U+e5fa-U+e6b7"
            "U+e700-U+e8ef" "U+ed00-U+efc1" "U+f000-U+f2ff" "U+f000-U+f2e0"
            "U+f300-U+f381" "U+f400-U+f533" "U+f0001-U+f1af0"
          ];
          in (builtins.concatStringsSep "," mappings) +
            " Symbols Nerd Font Mono";
        tab_bar_min_tabs              = 5;
      };
      themeFile   = "gruvbox-light-hard";
    };
  };
}

