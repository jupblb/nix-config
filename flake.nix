{
  description = "Nix configurations";

  inputs = {
    agenix              = {
      url    = "github:ryantm/agenix";
      inputs = { nixpkgs.follows = "nixpkgs-nixos"; };
    };
    home-manager-nixos  = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs-nixos"; };
    };
    home-manager-darwin = {
      url    = "github:nix-community/home-manager/release-25.05";
      inputs = { nixpkgs.follows = "nixpkgs-darwin"; };
    };
    mac-app-util        = {
      url    = "github:hraban/mac-app-util";
      inputs = { nixpkgs.follows = "nixpkgs-darwin"; };
    };
    nix-ai-tools        = { url = "github:numtide/nix-ai-tools"; };
    nixpkgs-nixos       = { url = "github:NixOS/nixpkgs/nixos-25.05"; };
    nixpkgs-darwin      = {
      url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    };
  };

  outputs = {
    self, nixpkgs-nixos, nixpkgs-darwin, home-manager-nixos,
    home-manager-darwin, agenix, mac-app-util, nix-ai-tools, ...
  }@inputs:
    let mkDevShell = pkgs: pkgs.mkShell {
      buildInputs = with pkgs; [
        agenix.packages.${pkgs.system}.default
        lua-language-server
        nodePackages.vim-language-server
      ];
      NVIM_LAZYDEV = "${pkgs.vimPlugins.lazydev-nvim}";
    };
    in {
      devShells = {
        aarch64-darwin.default =
          mkDevShell(import nixpkgs-darwin { system = "aarch64-darwin"; });
        x86_64-linux.default   =
          mkDevShell(import nixpkgs-nixos { system = "x86_64-linux"; });
      };
      nixosConfigurations = {
        hades    = nixpkgs-nixos.lib.nixosSystem({
          modules     = [
            ./hosts/hades.nix
            home-manager-nixos.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                (_: _: { amp = nix-ai-tools.packages.x86_64-linux.amp; })
              ];
            }
          ];
          specialArgs = { inherit inputs; };
          system      = "x86_64-linux";
        });
        dionysus = nixpkgs-nixos.lib.nixosSystem({
          modules     = [
            ./hosts/dionysus.nix
            home-manager-nixos.nixosModules.home-manager
            agenix.nixosModules.default
            {
              nixpkgs.overlays = [
                (_: _: { amp = nix-ai-tools.packages.x86_64-linux.amp; })
              ];
            }
          ];
          specialArgs = { inherit inputs; };
          system      = "x86_64-linux";
        });
      };

      homeConfigurations =
        let homeCfg = file: home-manager-darwin.lib.homeManagerConfiguration({
            modules =
              [ ./hosts/nyx.nix file mac-app-util.homeManagerModules.default ];
            pkgs    = import nixpkgs-darwin({
              overlays = [
                (_: _: { amp = nix-ai-tools.packages.aarch64-darwin.amp; })
              ];
              system   = "aarch64-darwin";
            });
        });
        in {
          jupblb = homeCfg ./hosts/nyx-personal.nix;
          michal = homeCfg ./hosts/nyx-work.nix;
        };
    };
}
