# Agents Reference

## Build Commands

- `nix flake check --impure` - Validate configurations (requires --impure due to SSH key paths)
- `sudo nixos-rebuild switch --flake .#hades` - Deploy hades config
- `sudo nixos-rebuild switch --flake .#dionysus` - Deploy dionysus config
- `nix develop` - Enter development shell

## Project Structure

- **Flake-based**: Use flake.nix for all system configurations
- **Host configs**: hades.nix (desktop), dionysus.nix (server)
- **Shared config**: default.nix imported by both hosts
- **No directories**: Configuration files are flat in repo root
- **Home manager**: Integrated via flake inputs, config in home-manager/

## Key Notes

- SSH host keys in default.nix require --impure for validation
- agenix secrets managed via flake input  
- Development shell includes: agenix, lua-language-server, vim-language-server
- Both hosts import default.nix for shared configuration
