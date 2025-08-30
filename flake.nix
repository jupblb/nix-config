{
  description = "NixOS configurations for hades and dionysus";

  inputs = {
    agenix       = {
      url    = "github:ryantm/agenix";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    flake-utils  = { url = "github:numtide/flake-utils"; };
    home-manager = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    nix-ai-tools = { url = "github:numtide/nix-ai-tools"; };
    nix-darwin   = {
      url = "github:LnL7/nix-darwin";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    nixpkgs      = { url = "github:NixOS/nixpkgs/nixos-25.05"; };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, agenix, nix-darwin, mac-app-util, nix-ai-tools, ... }@inputs:
    let common = { ... }: {
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
    };
    in flake-utils.lib.eachDefaultSystem(system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            agenix.packages.${system}.default
            lua-language-server
            nodePackages.vim-language-server
          ];

          NVIM_LAZYDEV = "${pkgs.vimPlugins.lazydev-nvim}";
        };
    }) // {
      nixosConfigurations = {
        hades = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hades.nix
            home-manager.nixosModules.home-manager
            common
          ];
          specialArgs = { inherit inputs; };
        };

        dionysus = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./dionysus.nix
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            common
          ];
          specialArgs = { inherit inputs; };
        };
      };

      darwinConfigurations = {
        nyx = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            home-manager.darwinModules.home-manager
            mac-app-util.darwinModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.jupblb = ./nyx.nix;
                extraSpecialArgs = { inherit inputs nix-ai-tools; };
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
