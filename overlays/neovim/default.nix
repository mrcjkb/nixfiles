{inputs, ...}: [
  inputs.neorocks.overlays.default
  inputs.neovim-nightly.overlays.default
  inputs.gen-luarc.overlays.default
  (import ./plugin-overlay.nix {inherit inputs;})
  (import ./neovim-overlay.nix {inherit inputs;})
]
