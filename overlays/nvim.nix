{inputs, ...}: [
  inputs.neorocks.overlays.default
  inputs.neovim-nightly.overlays.default
  inputs.gen-luarc.overlays.default
  (import ../modules/neovim/nix/plugin-overlay.nix {inherit inputs;})
  (import ../modules/neovim/nix/neovim-overlay.nix {inherit inputs;})
]
