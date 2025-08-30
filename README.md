# NixOS Configuration

Flake-based NixOS configuration for my machines

## Commands

``` bash
# Build and switch system
sudo nixos-rebuild switch --flake .#hades
sudo nixos-rebuild switch --flake .#dionysus

# Test configuration
nix flake check --impure

# Development environment
nix develop
# or use direnv: direnv allow
```
