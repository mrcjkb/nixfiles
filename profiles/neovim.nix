{config, ...}: {
  nixos.modules.neovim = {
    imports = [config.nixos.modules.neovim-package];
  };
}
