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
    claude-code = {
      enable   = true;
      package  = inputs.llm-agents.packages.aarch64-darwin.claude-code;
      settings = {
        permissions = {
          allow       =
            [ "Bash" "Read(~/Workspace/**)" "WebFetch" "WebSearch" ];
          defaultMode = "acceptEdits";
        };
        sandbox     = {
          autoAllowBashIfSandboxed = true;
          enabled                  = true;
        };
      };
    };

    home-manager = { enable = true; };
  };
}
