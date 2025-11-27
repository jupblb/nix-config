# Agents Reference

## Build Commands

- `nix flake check --impure` - Validate configurations (requires --impure due to SSH key paths)
- `sudo nixos-rebuild switch --flake .#hades --impure` - Deploy hades config
- `sudo nixos-rebuild switch --flake .#dionysus` - Deploy dionysus config
- `home-manager switch --flake .#jupblb@nyx` - Deploy nyx config (or just `home-manager switch`)
- `nix develop` - Enter development shell

## Project Structure

- **Flake-based**: Use flake.nix for all system configurations
- **Host configs**: hades.nix (desktop), dionysus.nix (server), nyx.nix (macOS)
- **Shared config**: default.nix imported by NixOS hosts only
- **No directories**: Configuration files are flat in repo root
- **Home manager**: Integrated via flake inputs, config in home-manager/
- **Darwin support**: nyx uses home-manager only, no nix-darwin

## Key Notes

- SSH host keys in default.nix require --impure for validation
- agenix secrets managed via flake input  
- Development shell includes: agenix, lua-language-server, vim-language-server
- NixOS hosts import default.nix for shared configuration
- nyx uses nixpkgs-25.11-darwin branch for macOS compatibility
- nix-ai-tools uses its own pinned nixpkgs for stability
- Home-manager config symlinked to ~/.config/home-manager/ for convenience
