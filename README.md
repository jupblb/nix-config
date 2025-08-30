# NixOS Configuration

Flake-based NixOS and Darwin configuration for multiple hosts.

## Hosts

- **hades**: Gaming desktop with NVIDIA GPU (NixOS)
- **dionysus**: Home server with media services (NixOS)  
- **nyx**: Development machine (macOS, home-manager only)

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

## Structure

- `flake.nix` - Main flake configuration
- `default.nix` - Shared configuration for NixOS hosts
- `hades.nix` - Gaming desktop config  
- `dionysus.nix` - Server config
- `nyx.nix` - macOS home-manager config
- `home-manager/` - User configuration modules
