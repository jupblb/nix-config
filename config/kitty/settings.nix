{
  allow_remote_control          = "yes";
  background                    = "#f9f5d7";
  clipboard_control             = "write-clipboard write-primary no-append";
  enabled_layouts               = "splits";
  enable_audio_bell             = "no";
  foreground                    = "#282828";
  listen_on                     = "unix:/tmp/kitty";
  scrollback_pager              =
    "kitty @ launch --type=overlay --stdin-source=@screen_scrollback nvim -R -c 'autocmd VimEnter * norm G{}' -";
  scrollback_pager_history_size = 4096;
}
