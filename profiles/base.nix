{config, ...}: {
  nixos.modules.base = {
    imports = [
      config.nixos.modules.overlays
      config.nixos.modules.base-system
      config.nixos.modules.home-manager-base
      config.nixos.modules.neovim
      config.nixos.modules.shell-aliases
    ];
  };
}
