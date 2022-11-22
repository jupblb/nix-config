{ pkgs, ... }: {
  programs.k9s = {
    enable       = true;
    settings.k9s = {
      clusters      = { dummy.namespace.active = "all"; };
      headless      = true;
      maxConnRetry  = 5;
      noExitOnCtrlC = true;
      noIcons       = true;
      refreshRate   = 5;
    };
  };

  xdg.configFile = {
    "k9s/skin.yml".source = pkgs.fetchurl {
      sha256 = "sha256-LSMjM8AOXp3bxV8M/vIWySXHrcMhvLUCvfJe3KTFNAU=";
      url    =
        "https://github.com/derailed/k9s/raw/master/skins/gruvbox-light.yml";
    };
  };
}
