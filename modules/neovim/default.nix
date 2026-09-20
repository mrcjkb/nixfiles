{...}: {
  nixos.modules.neovim-package = {pkgs, ...}: {
    environment.systemPackages = [pkgs.nvim-pkg];
  };
}
