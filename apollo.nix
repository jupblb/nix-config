{ config, lib, pkgs, ... }: {
  home = {
    activation    = {
      linkDesktopApplications =
        lib.hm.dag.entryAfter [ "writeBoundary" "createXdgUserDirectories" ] ''
          $DRY_RUN_CMD ln -sfn \
            ${config.home.homeDirectory}/.nix-profile/share/applications \
            ${config.xdg.dataHome}/applications/home-manager
        '';
    };
    homeDirectory = "/home/deck";
    stateVersion  = "22.11";
    username      = lib.mkForce "deck";
  };

  imports = [
    ./home-manager
    ./home-manager/fish
    ./home-manager/lf
    ./home-manager/kitty.nix
    ./home-manager/neovim
  ];

  nixpkgs.config.packageOverrides = _: {
    nixGl =
      let t = fetchTarball
        "https://github.com/guibou/nixGL/archive/master.tar.gz";
      in import "${t}/default.nix" { enable32bits = false; };
  };

  programs = {
    kitty = {
      package = pkgs.symlinkJoin {
        name        = "kitty-glx";
        paths       = with pkgs; [ kitty ];
        postBuild   =
          let app = pkgs.writeShellScript "kitty-glx-sh" ''
            ${lib.meta.getExe pkgs.nixGl.nixGLMesa} \
              ${lib.meta.getExe pkgs.kitty} --start-as fullscreen
          '';
          in "ln -sfn ${app} $out/bin/kitty";
      };
    };

    home-manager.enable = true;
  };

  targets.genericLinux.enable = true;
}
