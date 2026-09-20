# nixfiles

[![Nix build](https://github.com/MrcJkb/nixfiles/actions/workflows/nix-build.yml/badge.svg)](https://github.com/MrcJkb/nixfiles/actions/workflows/nix-build.yml)

My NixOS system configs and dotfiles.

## Outputs

```sh
nixos-rebuild switch --flake .#<host>

nix build .#nixosConfigurations.<host>.config.system.build.toplevel
nix build .#images.rpi4
```

## Neovim

My Neovim config (derivations and Lua) lives in [`modules/neovim`](./modules/neovim).
It can be run with:

```sh
nix run .#nvim
```

It is based on [kickstart-nix.nvim](https://github.com/nix-community/kickstart-nix.nvim),
a Nix flake template for Neovim derivations.

## XMonad / XMobar

My XMonad config (Haskell: `xmonadrc` and `xmobar-app`) lives in
[`modules/xmonad`](./modules/xmonad). The status bar can be run with:

```sh
nix run .#xmobar-app
```
