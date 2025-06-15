{ pkgs, ... }: {
  programs.qutebrowser = {
    enable        = true;
    extraConfig   = builtins.readFile(pkgs.fetchurl({
      sha256 = "sha256-OFwPRBZ/8ZrDhVsRacAqRRaMnr+kaznWgUmCkfHhK1I=";
      url    =
        "https://github.com/tinted-theming/base16-qutebrowser/raw/main/themes/default/base16-gruvbox-light-hard.config.py";
    }));
    quickmarks    = {
      home-manager =
        "https://nix-community.github.io/home-manager/options.xhtml";
      nixpkgs      = "https://github.com/NixOS/nixpkgs";
    };
    searchEngines = {
      DEFAULT = "https://kagi.com/search?q={}";
      g       = "https://www.google.com/search?hl=en&q={}";
      maps    = "https://www.google.com/maps/search/{}";
      nix     = "https://wiki.nixos.org/w/index.php?search={}";
      nixos   = "https://search.nixos.org/options?query={}";
    };
    settings      = {
      content   = {
        notifications          = { enabled = false; };
        pdfjs                  = true;
        prefers_reduced_motion = true;
      };
      statusbar = { show = "in-mode"; };
      tabs      = { show = "never"; };
      url       = {
        start_pages =
          "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
      };
      window    = { hide_decoration = true; };
    };
  };
}
