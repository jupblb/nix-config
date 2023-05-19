{ lib, pkgs, ... }: {
  home = {
    activation.cachix = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD cachix use devenv
    '';
    packages          =
      let devenv =
        (import (fetchTarball "https://github.com/cachix/devenv/archive/latest.tar.gz")).default;
      in with pkgs; [ cachix devenv ];
    sessionVariables  = { DIRENV_WARN_TIMEOUT = "1h"; };
  };

  programs.direnv = {
    config     = {
      bash_path     = "${pkgs.bashInteractive}/bin/bash";
      disable_stdin = true;
      strict_env    = true;
    };
    enable     = true;
    nix-direnv = { enable = true; };
  };
}
