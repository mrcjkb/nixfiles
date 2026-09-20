# nixfiles

[![Nix build](https://github.com/MrcJkb/nixfiles/actions/workflows/nix-build.yml/badge.svg)](https://github.com/MrcJkb/nixfiles/actions/workflows/nix-build.yml)

My NixOS system configs and dotfiles.

## Outputs

```sh
nixos-rebuild switch --flake .#<host>

nix build .#nixosConfigurations.<host>.config.system.build.toplevel
nix build .#images.rpi4
```
