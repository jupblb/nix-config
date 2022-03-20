{
  allow_remote_control               = "yes";
  clipboard_control                  = "write-clipboard write-primary no-append";
  enabled_layouts                    = "splits";
  enable_audio_bell                  = "no";
  listen_on                          = "unix:/tmp/kitty";
  macos_option_as_alt                = "left";
  macos_quit_when_last_window_closed = "yes";
  scrollback_pager                   =
    "kitty @ launch --type=overlay --stdin-source=@screen_scrollback nvim -R -c 'autocmd VimEnter * norm G{}' -";
  scrollback_pager_history_size      = 4096;
  symbol_map                         =
    let mappings = [
      "U+23FB-U+23FE" "U+2B58" "U+E200-U+E2A9" "U+E0A0-U+E0A3" "U+E0B0-U+E0BF"
      "U+E0C0-U+E0C8" "U+E0CC-U+E0CF" "U+E0D0-U+E0D2" "U+E0D4" "U+E700-U+E7C5"
      "U+F000-U+F2E0" "U+2665" "U+26A1" "U+F400-U+F4A8" "U+F67C" "U+E000-U+E00A"
      "U+F300-U+F313" "U+E5FA-U+E62B"
    ];
    in (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
}
