# nixfiles

[![Nix build](https://github.com/MrcJkb/nixfiles/actions/workflows/nix-build.yml/badge.svg)](https://github.com/MrcJkb/nixfiles/actions/workflows/nix-build.yml)

My NixOS system configs and dotfiles.

## Raspberry Pi 4 image

```nix
nix build .#nixosConfigurations.images.rpi4
```
