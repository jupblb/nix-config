{ pkgs, ... }: {
  home.sessionVariables = {
    _ZO_FZF_OPTS =
      let preview = "${pkgs.exa}/bin/exa -RT -L 2 --icons {2..} | head -200";
      in "$FZF_DEFAULT_OPTS --no-sort --reverse -1 -0 --preview '${preview}'";
  };

  programs.zoxide = {
    enable                = true;
    enableBashIntegration = false;
    options               = [ "--cmd cd" ];
  };
}
