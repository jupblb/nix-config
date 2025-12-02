{
  description = "Nix configurations";

  inputs = {
    agenix         = { url = "github:ryantm/agenix"; };
    home-manager   = {
      url = "github:nix-community/home-manager/release-25.11";
    };
    nix-ai-tools   = { url = "github:numtide/nix-ai-tools"; };
    nixpkgs-nixos  = { url = "github:NixOS/nixpkgs/nixos-25.11"; };
    nixpkgs-darwin = { url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin"; };
  };

  outputs = {
    self, nixpkgs-nixos, nixpkgs-darwin, home-manager, agenix, nix-ai-tools,
    ...
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
            home-manager.nixosModules.home-manager
            {
              nixpkgs.overlays = [
                (_: _: { amp-cli = nix-ai-tools.packages.x86_64-linux.amp; })
              ];
            }
          ];
          specialArgs = { inherit inputs; };
          system      = "x86_64-linux";
        });
        dionysus = nixpkgs-nixos.lib.nixosSystem({
          modules     = [
            ./hosts/dionysus.nix
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            {
              nixpkgs.overlays = [
                (_: _: { amp-cli = nix-ai-tools.packages.x86_64-linux.amp; })
              ];
            }
          ];
          specialArgs = { inherit inputs; };
          system      = "x86_64-linux";
        });
      };

      homeConfigurations =
        let homeCfg = file: home-manager.lib.homeManagerConfiguration({
            modules = [ ./hosts/nyx.nix file ];
            pkgs    = import nixpkgs-darwin({
              overlays = with nix-ai-tools.packages.aarch64-darwin; [
                (_: _: {
                  amp-cli     = amp;
                  claude-code = claude-code;
                })
              ];
              system   = "aarch64-darwin";
            });
        });
        in {
          jupblb = homeCfg(./hosts/nyx-personal.nix);
          michal = homeCfg(./hosts/nyx-work.nix);
        };
    };
}
