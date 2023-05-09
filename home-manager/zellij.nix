_: {
  programs.zellij = {
    enable   = true;
    settings = {
      default_layout = "default"; # compact
      pane_frames    = true; # false
      theme          = "gruvbox-light";
    };
  };
}
