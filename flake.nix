{
  description = "NixOS configurations for hades and dionysus";

  inputs = {
    agenix       = {
      url    = "github:ryantm/agenix";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    home-manager = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs-darwin"; };
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs = { nixpkgs.follows = "nixpkgs"; };
    };
    nix-ai-tools = { 
      url = "github:numtide/nix-ai-tools";
      # Don't follow nixpkgs - let it use its own pinned version
    };
    nixpkgs      = { url = "github:NixOS/nixpkgs/nixos-25.05"; };
    nixpkgs-darwin = { url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin"; };
  };

  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, home-manager-darwin, agenix, mac-app-util, nix-ai-tools, ... }@inputs:
    let 
      common = { ... }: {
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
      };
      mkDevShell = system: 
        let pkgs = import nixpkgs { inherit system; };
        in pkgs.mkShell {
          buildInputs = with pkgs; [
            agenix.packages.${system}.default
            lua-language-server
            nodePackages.vim-language-server
          ];
          NVIM_LAZYDEV = "${pkgs.vimPlugins.lazydev-nvim}";
        };
    in {
      devShells = {
        aarch64-darwin.default = mkDevShell "aarch64-darwin";
        x86_64-linux.default = mkDevShell "x86_64-linux";
      };
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

      homeConfigurations = {
        "jupblb@nyx" = home-manager-darwin.lib.homeManagerConfiguration {
          pkgs = import nixpkgs-darwin { 
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
          modules = [
            mac-app-util.homeManagerModules.default
            ./nyx.nix
          ];
          extraSpecialArgs = { inherit inputs nix-ai-tools; };
        };
      };
    };
}
