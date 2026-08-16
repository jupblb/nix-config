{ inputs, pkgs, ... }: {
  home = {
    homeDirectory = "/Users/jupblb";
    packages      = with pkgs; [ bashInteractive utm ];
    stateVersion  = "26.05";
    username      = "jupblb";
  };

  imports = [
    inputs.mac-app-util.homeManagerModules.default
    ../home-manager
    ../home-manager/amp.nix
    ../home-manager/apple.nix
    ../home-manager/fish
    ../home-manager/kitty.nix
    ../home-manager/lf
    ../home-manager/neovim
  ];

  nixpkgs = {
    config   = { allowUnfree = true; };
    overlays = with inputs.llm-agents.packages.aarch64-darwin;
      [ (_: _: { amp-cli = amp; }) ];
  };

  programs = {
    home-manager = { enable = true; };
  };
}
