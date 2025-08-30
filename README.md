# NixOS Configuration

Flake-based NixOS and Darwin configuration for multiple hosts.

## Commands

```bash
# NixOS systems
sudo nixos-rebuild switch --flake .#hades
sudo nixos-rebuild switch --flake .#dionysus

# macOS home-manager (nyx)
home-manager switch --flake .#jupblb@nyx
# or just: home-manager switch

# Test configuration
nix flake check --impure

# Development environment
nix develop
# or use direnv: direnv allow
```
