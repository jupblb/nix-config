_: {
  programs.qutebrowser = {
    enable        = true;
    extraConfig   = builtins.readFile ./per-domain.py;
    quickmarks    = {
      hacker-news  = "news.ycombinator.com";
      home-manager = "nix-community.github.io/home-manager/options.html";
      nixpkgs      = "github.com/NixOS/nixpkgs";
    };
    searchEngines = {
      DEFAULT     = "google.com/search?hl=en&q={}";
      arch        = "wiki.archlinux.org/?search={}";
      google      = "google.com/search?hl=en&q={}";
      hacker-news = "google.com/search?hl=en&q={}+site%3Anews.ycombinator.com";
      nixos       = "search.nixos.org/options?channel=unstable&query={}";
      nixpkgs     = "search.nixos.org/packages?channel=unstable&query={}";
      nitter      = "nitter.net/search?f=users&q={}";
      reddit      = "google.com/search?hl=en&q={}+site%3Areddit.com";
      youtube     = "youtube.com/results?search_query={}";
    };
    settings      = {
      content.autoplay = false;
      fonts.default_family = "PragmataPro Mono";
#     BROKEN: https://github.com/qutebrowser/qutebrowser/issues/2236
#     statusbar.show = "in-mode";
    };
  };
}
