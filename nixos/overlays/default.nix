self: pkgs:

let
  all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master") {};
in { 
  _1password'        = pkgs._1password.overrideAttrs (old: rec {
    src     = pkgs.fetchzip {
      url = "https://cache.agilebits.com/dist/1P/op/pkg/v${version}/op_linux_amd64_v${version}.zip";
      sha256 = "sha256:1bhvv7d4l046ji6g40zlcjaf3z803pplg6hhpy18z343gwl1z0s2";
      stripRoot = false;
    };
    version = "0.9.1";
  });
  all-hies'         = all-hies.selection { selector = p: p; };
  git'              = pkgs.buildEnv {
    name  = "git";
    paths = with self; [ git gitAndTools.diff-so-fancy ];
  };
  i3status'         = pkgs.callPackage ./i3status { };
  idea-ultimate'    = pkgs.callPackage ./idea { };
  kitty'            = pkgs.callPackage ./kitty { };
  neovim'           = pkgs.callPackage ./neovim { };
  neovim''          = pkgs.buildEnv {
    name  = "nvim";
    paths = with self; [ all-hies' neovim' nodePackages.bash-language-server openjdk8 ];
  };
  redshift'         = pkgs.callPackage ./redshift { inherit (pkgs.python3Packages) python pygobject3 pyxdg wrapPython; };
  sbt'              = pkgs.sbt.override { jre = pkgs.graalvm8; };
  vaapiIntel'       = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  vim'              = pkgs.callPackage ./vim { inherit (pkgs.vimUtils) buildVimPluginFrom2Nix; }; 
}
