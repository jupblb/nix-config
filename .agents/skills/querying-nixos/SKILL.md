---
name: querying-nixos
description: Searches NixOS packages, options, Home Manager, nix-darwin, Nixvim, and Nix functions via mcp-nixos. Use when working with Nix configurations or looking up NixOS/Home Manager/nix-darwin options and packages.
---

# Querying NixOS Resources

Use the `mcp__nixos__nix` tool for unified queries and `mcp__nixos__nix_versions` for version history.

## nix tool

```
nix(action, query, source, type, channel, limit)
```

### Actions
- `search` — search packages, options, programs, or flakes
- `info` — detailed info about a package or option
- `stats` — counts and categories
- `options` — browse options by prefix
- `channels` — list available channels
- `flake-inputs` — explore local flake inputs from Nix store
- `cache` — check binary cache status

### Sources
- `nixos` — packages, options, programs
- `home-manager` — Home Manager options
- `darwin` — nix-darwin options
- `nixvim` — Nixvim options
- `flakes` — community flakes (search.nixos.org)
- `flakehub` — FlakeHub registry
- `noogle` — Nix function signatures (noogle.dev)
- `wiki` — NixOS Wiki
- `nix-dev` — official Nix docs
- `nixhub` — package metadata and store paths

## nix_versions tool

```
nix_versions(package, version, limit)
```

Find historical package versions with nixpkgs commit hashes.
