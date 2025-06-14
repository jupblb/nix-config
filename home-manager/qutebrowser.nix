{ pkgs, ... }: {
  programs.qutebrowser = {
    enable         = true;
    loadAutoconfig = true;
    package        = pkgs.qutebrowser.override({ enableWideVine = true; });
    settings       = {};
  };
}
