{
  description = "Nix configurations";

  inputs = {
    agenix         = { url = "github:ryantm/agenix"; };
    home-manager   = {
      url = "github:nix-community/home-manager/release-26.05";
    };
    llm-agents     = { url = "github:numtide/llm-agents.nix"; };
    mac-app-util   = { url = "github:hraban/mac-app-util"; };
    nixpkgs-nixos  = { url = "github:NixOS/nixpkgs/nixos-26.05"; };
    nixpkgs-darwin = { url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin"; };
  };

  outputs = {
    self, agenix, home-manager, llm-agents, mac-app-util, nixpkgs-darwin,
    nixpkgs-nixos, ...
  }@inputs: {
    devShells =
      let mkDevShell = pkgs: pkgs.mkShell {
        buildInputs  = with pkgs; [
          agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
          lua-language-server mcp-nixos vim-language-server
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

    homeConfigurations = {
      nyx = home-manager.lib.homeManagerConfiguration({
        extraSpecialArgs = { inherit inputs; };
        modules          = [ ./hosts/nyx.nix ];
        pkgs             = import nixpkgs-darwin { system = "aarch64-darwin"; };
      });
    };

    nixosConfigurations  = {
      hades    = nixpkgs-nixos.lib.nixosSystem({
        modules     = [ ./hosts/hades.nix ];
        specialArgs = { inherit inputs; };
        system      = "x86_64-linux";
      });
      dionysus = nixpkgs-nixos.lib.nixosSystem({
        modules     = [ ./hosts/dionysus.nix ];
        specialArgs = { inherit inputs; };
        system      = "x86_64-linux";
      });
    };
  };
}
