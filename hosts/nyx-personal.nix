{ pkgs, ... }: {
  imports = [
    ../home-manager
    (import ../home-manager/amp { inherit pkgs; })
    ../home-manager/fish
    ../home-manager/kitty.nix
    ../home-manager/lf
    ../home-manager/neovim
  ];

  services = { syncthing.enable = true; };
}
