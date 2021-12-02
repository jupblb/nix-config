{
  background                    = "#f9f5d7";
  clipboard_control             =
    "write-clipboard write-primary no-append";
  enabled_layouts               = "splits";
  enable_audio_bell             = "no";
  foreground                    = "#282828";
  scrollback_pager              =
    "nvim -c 'call clearmatches() | Man! | set syntax=off | autocmd VimEnter * norm G{}'";
  scrollback_pager_history_size = 4096;
}
