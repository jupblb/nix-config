{
  description = "Nix configurations";

  inputs = {
    agenix         = { url = "github:ryantm/agenix"; };
    home-manager   = {
      url = "github:nix-community/home-manager/release-25.11";
    };
    llm-agents     = { url = "github:numtide/llm-agents.nix"; };
    nix-darwin     = {
      url    = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs = { nixpkgs.follows = "nixpkgs-darwin"; };
    };
    nixpkgs-nixos  = { url = "github:NixOS/nixpkgs/nixos-25.11"; };
    nixpkgs-darwin = { url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin"; };
  };

  outputs = {
    self, agenix, home-manager, llm-agents, nix-darwin, nixpkgs-darwin,
    nixpkgs-nixos, ...
  }@inputs: {
    darwinConfigurations = {
      nyx = nix-darwin.lib.darwinSystem({
        modules     = [ ./hosts/nyx.nix ];
        specialArgs = { inherit inputs; };
      });
    };

    devShells =
      let mkDevShell = pkgs: pkgs.mkShell {
        buildInputs  = with pkgs; [
          agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          lua-language-server vim-language-server
        ];
        NVIM_LAZYDEV = "${pkgs.vimPlugins.lazydev-nvim}";
      };
      in {
        aarch64-darwin.default = mkDevShell(
          import nixpkgs-darwin { system = "aarch64-darwin"; }
        );
        x86_64-linux.default   = mkDevShell(
          import nixpkgs-nixos { system = "x86_64-linux"; }
        );
      };

    nixosConfigurations  = {
      hades    = nixpkgs-nixos.lib.nixosSystem({
        modules     = [ ./hosts/hades.nix ];
        specialArgs = { inherit inputs; };
        system      = "x86_64-linux";
      });
      dionysus = nixpkgs-nixos.lib.nixosSystem({
        modules     = [ ./hosts/dionysus.nix agenix.nixosModules.default ];
        specialArgs = { inherit inputs; };
        system      = "x86_64-linux";
      });
    };
  };
}
