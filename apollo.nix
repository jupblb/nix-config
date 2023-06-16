{ config, lib, pkgs, ... }: {
  fonts.fontconfig.enable = true;

  home = {
    activation    = {
      linkDesktopApplications =
        lib.hm.dag.entryAfter [ "writeBoundary" "createXdgUserDirectories" ] ''
          $DRY_RUN_CMD ln -sfn ${config.home.homeDirectory}/.nix-profile/share/applications \
            ${config.xdg.dataHome}/"applications/home-manager"
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
    ./home-manager/direnv.nix
    ./home-manager/qutebrowser
  ];

  nixpkgs.config.packageOverrides = _: {
    nixGl =
      let t = fetchTarball
        "https://github.com/guibou/nixGL/archive/master.tar.gz";
      in import "${t}/default.nix" { enable32bits = false; };
  };

  programs = {
    kitty               = {
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
    qutebrowser.package = pkgs.symlinkJoin {
      name        = "qutebrowser-glx";
      paths       = with pkgs; [ qutebrowser ];
      postBuild   =
        let app = pkgs.writeShellScript "qutebrowser-glx-sh" ''
          ${lib.meta.getExe pkgs.nixGl.nixGLMesa} \
            ${lib.meta.getExe pkgs.qutebrowser}
        '';
        in "ln -sfn ${app} $out/bin/qutebrowser";
    };
  };

  services.gpg-agent = {
    enable         = true;
    pinentryFlavor = "qt";
  };

  targets.genericLinux.enable = true;
}
