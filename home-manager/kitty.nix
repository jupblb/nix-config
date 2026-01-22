{ lib, pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home.shellAliases = {
    icat = "kitty +kitten icat";
    ssh  = "kitty +kitten ssh";
  };

  programs = {
    git = {
      settings = {
        diff = {
          guitool = "kitty.gui";
          tool    = "kitty";
        };
        difftool =
          let conf = pkgs.writeText "kitty-diff.conf"
            (lib.generators.toKeyValue {
              mkKeyValue = lib.generators.mkKeyValueDefault {} " ";
            } {
              pygments_style       = "gruvbox-light";
              dark_pygments_style  = "gruvbox-dark";
              replace_tab_by       = "\\x20\\x20";
              foreground           = "#3c3836";
              background           = "#f9f5d7";
              title_fg             = "#3c3836";
              title_bg             = "#f9f5d7";
              margin_fg            = "#928374";
              margin_bg            = "#f9f5d7";
              removed_bg           = "#f9d8bc";
              highlight_removed_bg = "#fa9f86";
              removed_margin_bg    = "#f9f5d7";
              added_bg             = "#eeebba";
              highlight_added_bg   = "#d9d87f";
              added_margin_bg      = "#f9f5d7";
              filler_bg            = "#f9f5d7";
              hunk_margin_bg       = "#f9f5d7";
              hunk_bg              = "#f9f5d7";
            });
        in {
          prompt          = false;
          trustExitCode   = true;
          "kitty".cmd     = "kitten diff --config ${conf} $LOCAL $REMOTE";
          "kitty.gui".cmd = "kitten diff --config ${conf} $LOCAL $REMOTE";
        };
      };
    };

    fish = {
      interactiveShellInit = ''
        set -gx __fish_git_prompt_color af3a03
        set -gx __fish_git_prompt_color_dirtystate b57614
        set -gx __fish_git_prompt_color_merging af3a03
        set -gx __fish_git_prompt_color_stagedstate 79740e
        set -gx __fish_git_prompt_color_untrackedfiles 427b58
      '';
    };

    kitty = {
      enable      = true;
      font        = {
        name    = "Iosevka Term";
        package = pkgs.iosevka-bin.override { variant = "SGr-IosevkaTerm"; };
        size    = 10;
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
        sync_to_monitor               = "no";
        tab_bar_min_tabs              = 4;
      };
      themeFile   = "gruvbox-light-hard";
    };
  };
}
