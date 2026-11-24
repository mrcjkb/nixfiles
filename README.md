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

My Neovim config (the derivation overlay and Lua sources) lives in
[`overlays/neovim`](./overlays/neovim), with the NixOS module in
[`modules/neovim.nix`](./modules/neovim.nix).
It can be run with:

```sh
nix run .#nvim
```

It is based on [kickstart-nix.nvim](https://github.com/nix-community/kickstart-nix.nvim),
a Nix flake template for Neovim derivations.

## XMonad / XMobar

My XMonad config (Haskell: `xmonadrc` and `xmobar-app`) lives in
[`overlays/xmonad`](./overlays/xmonad), with the NixOS session module in
[`modules/xmonad`](./modules/xmonad). The status bar can be run with:

```sh
nix run .#xmobar-app
```

## River-rhine / Rhinebar

My River-rhine config (Haskell: `river-rhine-config` and `rhinebar-config`) lives in
[`overlays/river-rhine`](./overlays/river-rhine), with the NixOS module in
[`modules/river-rhine`](./modules/river-rhine). Both configs are built by Nix, so the
window manager needs no runtime recompile step. They can be built with:

```sh
nix build .#river-rhine-config .#rhinebar-config
```

The display manager lists both `river-rhine` and `xmonad`. `river-rhine` is the default
session.
