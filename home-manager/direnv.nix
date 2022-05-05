{ pkgs, ... }: {
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
