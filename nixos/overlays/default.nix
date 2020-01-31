self: pkgs:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in { 
  all-hies'         = all-hies.selection { selector = p: p; };
  git'              = pkgs.buildEnv {
    name        = "git";
    paths       = with self; [ git gitAndTools.diff-so-fancy ];
  };
  gnome-screenshot' = pkgs.gnome3.gnome-screenshot;
  idea-ultimate'    = pkgs.callPackage ./idea { };
  kitty'            = pkgs.callPackage ./kitty { };
  neovim'           = pkgs.callPackage ./neovim { };
  neovim''          = pkgs.buildEnv {
    name        = "nvim";
    paths       = with self; [ all-hies' neovim' nodePackages.bash-language-server openjdk8 ];
  };
  sbt'              = pkgs.sbt.override { jre = pkgs.graalvm8; };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  vim'              = pkgs.callPackage ./vim { inherit (pkgs.vimUtils) buildVimPluginFrom2Nix; }; 
}
